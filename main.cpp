
#define _UNICODE
#define UNICODE

#include <stlsoft/stlsoft.h>

#if _STLSOFT_VER < 0x010b01c3
# error requires STLSoft v1.11.1-rc3 or later
#endif
#if __cplusplus < 201702L
# error requires C++17 or later
#endif

#include <platformstl/filesystem/path_functions.h>
#include <stlsoft/smartptr/scoped_handle.hpp>
#include <stlsoft/util/string/snprintf.h>
#include <winstl/exception/winstl_exception.hpp>
#include <winstl/exception/access_exception.hpp>
#include <winstl/filesystem/memory_mapped_file.hpp>
#include <winstl/synch/event.hpp>

#include <psapi.h>
#include <Windows.h>

#include <cstdlib>
#include <iostream>
#include <thread>


#define PROGRAM_VER_MAJOR   0
#define PROGRAM_VER_MINOR   0
#define PROGRAM_VER_PATCH   1


union Payload
{
#if defined(__GNUC__) && !defined(__clang__)
    __extension__
#endif
    struct
    {
        DWORD   pid;
        CHAR    content[1];
    };
    UCHAR bytes[4096];
};

// [[noreturn]]
__declspec(noreturn)
void throw_(
    DWORD       le
,   char const* msg
)
{
    using namespace winstl;

    if (ERROR_ACCESS_DENIED == le)
    {
        STLSOFT_THROW_X(access_exception(msg, le));
    }
    else
    {
        STLSOFT_THROW_X(winstl_exception(msg, le));
    }
}


std::string GetProcessNameFromPid(DWORD pid) {
    HANDLE hProcess = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, pid);
    if (hProcess == NULL) {
        return "Error: Could not open process";
    }

    char buffer[MAX_PATH];
    if (GetProcessImageFileNameA(hProcess, buffer, MAX_PATH) == 0) {
        CloseHandle(hProcess);
        return "Error: Could not get image file name";
    }

    CloseHandle(hProcess);

    std::string fullPath(buffer);
    size_t lastSlash = fullPath.find_last_of("\\");
    std::string processName = (lastSlash == std::string::npos) ? fullPath : fullPath.substr(lastSlash + 1);

    return processName;
}

// [[noreturn]]
__declspec(noreturn)
void run()
{
    winstl::event   ev_buffer_ready(L"DBWIN_BUFFER_READY", false, false);
    winstl::event   ev_data_ready(L"DBWIN_DATA_READY", false, false);

    HANDLE const    hFileMap    =   CreateFileMappingA(INVALID_HANDLE_VALUE, NULL, PAGE_READWRITE, 0, sizeof(Payload), "DBWIN_BUFFER");

    if (NULL == hFileMap)
    {
        DWORD const le = ::GetLastError();

        throw_(le, "failed to create file-mapping");
    }

    stlsoft::scoped_handle  scoper_fm(hFileMap, ::CloseHandle);

    Payload* const          payload = (Payload*)::MapViewOfFile(hFileMap, SECTION_MAP_READ, 0, 0, 0);

    if (NULL == payload)
    {
        DWORD const le = ::GetLastError();

        throw_(le, "failed to map view");
    }

    HANDLE hStderr = GetStdHandle(STD_ERROR_HANDLE);

    for (;;)
    {
        ev_buffer_ready.set();

        DWORD const wait = ::WaitForSingleObject(ev_data_ready.handle(), INFINITE);

        if (WAIT_OBJECT_0 != wait)
        {
            DWORD const le = ::GetLastError();

            throw_(le, "failed to wait for buffer-ready");
        }
        size_t len = strlen(payload->content);

        for ( ; 0 != len; --len)
        {
            if ('\r' != payload->content[len - 1] &&
                '\n' != payload->content[len - 1])
            {
                break;
            }
        }

        if (len != 0)
        {
            using stlsoft::stlsoft_C_snprintf;

            char    msg[4096];
            int     r = stlsoft_C_snprintf(msg, "%lu - %s: %.*s", payload->pid, GetProcessNameFromPid(payload->pid).c_str(), (int)len, payload->content);
            DWORD   numWritten;

            if (r < 5)
            {
                ::WriteFile(hStderr, "could not prepare output line\r\n", 31, &numWritten, NULL);
            }
            else
            {
                if (r > int(STLSOFT_NUM_ELEMENTS(msg) - 3))
                {
                    msg[STLSOFT_NUM_ELEMENTS(msg) - 3] = '\r';
                    msg[STLSOFT_NUM_ELEMENTS(msg) - 2] = '\n';
                    msg[STLSOFT_NUM_ELEMENTS(msg) - 1] = '\0';
                }
                else
                {
                    msg[r++] = '\r';
                    msg[r++] = '\n';
                    msg[r] = '\0';
                }

                ::WriteFile(hStderr, msg, (DWORD)r, &numWritten, NULL);
            }
        }
    }
}


int wmain(int argc, wchar_t* argv[])
{
	stlsoft::string_slice_w_t const program_name = platformstl::get_executable_name_from_path(argv[0]);

    try
    {
        switch (argc)
        {
        case 2:

            if (0 == std::wcscmp(L"--help", argv[1]))
            {
                std::wcout
                    << L"USAGE: "
                    << program_name
                    << L" [ { --help | --version } ]"
                    << std::endl;

                return EXIT_SUCCESS;
            }
            else
            if (0 == std::wcscmp(L"--version", argv[1]))
            {
                std::wcout
                    << program_name
                    << L" v"
                    << PROGRAM_VER_MAJOR
                    << L'.'
                    << PROGRAM_VER_MINOR
                    << L'.'
                    << PROGRAM_VER_PATCH
                    << std::endl;

                return EXIT_SUCCESS;
            }
            else
            {
                std::wcerr
                    << program_name
                    << L": unrecognised argument '"
                    << argv[1]
                    << L"'; use --help for usage"
                    << std::endl;

                return EXIT_FAILURE;
            }
            break;
        case 1:

            run();

#ifndef NDEBUG

            fwprintf(
                stderr
            ,   L"%.*s: %s:%d: UNEXPECTED\n"
            ,   int(program_name.len), program_name.ptr
            ,   STLSOFT_STRINGIZE_w(__FILE__), __LINE__
            );

            ::DebugBreak();

            return EXIT_FAILURE;
#endif
        default:

            std::wcerr
                << program_name
                << L": too many arguments; use --help for usage"
                << std::endl;

            return EXIT_FAILURE;
        }
    }
    catch (std::bad_alloc&)
    {
        fputws(L"out of memory\n", stderr);
    }
    catch (std::exception& x)
    {
        fwprintf(
            stderr
        ,   L"%.*s: process failed: %S\n"
        ,   int(program_name.len), program_name.ptr
        ,   x.what()
        );
    }

    return EXIT_SUCCESS;
}

