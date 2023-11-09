/* <stdarg.h> for the DevTalks Zig C compiler */

#pragma once
#define __STDC_VERSION_STDARG_H__ 0

typedef __builtin_va_list va_list;
#define va_start(ap, param) __builtin_va_start(ap, param)
#define va_end(ap) __builtin_va_end(ap)
#define va_arg(ap, type) __builtin_va_arg(ap, type)

#define __va_copy(d, s) __builtin_va_copy(d, s)

#if __STDC_VERSION__ >= 199901L || !defined(__STRICT_ANSI__)
#define va_copy(d, s) __builtin_va_copy(d, s)
#endif

#ifndef __GNUC_VA_LIST
#define __GNUC_VA_LIST 1
typedef __builtin_va_list __gnuc_va_list;
#endif
