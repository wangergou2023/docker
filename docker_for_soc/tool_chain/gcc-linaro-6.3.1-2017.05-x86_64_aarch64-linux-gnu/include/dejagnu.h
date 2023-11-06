/* DejaGnu unit testing header.
   Copyright (C) 2000, 2001, 2002, 2004, 2006 Free Software
   Foundation, Inc.

This file is part of DejaGnu.

DejaGnu is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

DejaGnu is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with DejaGnu; if not, write to the Free Software Foundation,
Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1301, USA.  */

#ifndef __DEJAGNU_H__
#define __DEJAGNU_H__

#include <stdio.h>
#include <stdarg.h>
#include <string.h>

/* If you have problems with DejaGnu dropping failed, untested, or
 * unresolved messages generated by a unit testcase, then:  */

/* #define _DEJAGNU_WAIT_  */

#ifdef _DEJAGNU_WAIT_
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#endif

static int passed;
static int failed;
static int untest;
static int unresolve;
static int xfailed;
static int xpassed;

static char buffer[512];

void
wait (void)
{
#ifdef _DEJAGNU_WAIT_
  fd_set rfds;
  struct timeval tv;

  FD_ZERO (&rfds);
  tv.tv_sec = 0;
  tv.tv_usec = 1;

  select (0, &rfds, NULL, NULL, &tv);
#endif
}

static inline void
pass (const char* fmt, ...)
{
  va_list ap;

  passed++;
  va_start (ap, fmt);
  vsnprintf (buffer, sizeof (buffer), fmt, ap);
  va_end (ap);
  printf ("\tPASSED: %s\n", buffer);
  wait ();
}

static inline void
xpass (const char* fmt, ...)
{
  va_list ap;

  passed++;
  va_start (ap, fmt);
  vsnprintf (buffer, sizeof (buffer), fmt, ap);
  va_end (ap);
  printf ("\tXPASSED: %s\n", buffer);
  wait ();
}

static inline void
fail (const char* fmt, ...)
{
  va_list ap;

  failed++;
  va_start (ap, fmt);
  vsnprintf (buffer, sizeof (buffer), fmt, ap);
  va_end (ap);
  printf ("\tFAILED: %s\n", buffer);
  wait ();
}

static inline void
xfail (const char* fmt, ...)
{
  va_list ap;

  failed++;
  va_start (ap, fmt);
  vsnprintf (buffer, sizeof (buffer), fmt, ap);
  va_end (ap);
  printf ("\tXFAILED: %s\n", buffer);
  wait ();
}

static inline void
untested (const char* fmt, ...)
{
  va_list ap;

  untest++;
  va_start (ap, fmt);
  vsnprintf (buffer, sizeof (buffer), fmt, ap);
  va_end (ap);
  printf ("\tUNTESTED: %s\n", buffer);
  wait ();
}

static inline void
unresolved (const char* fmt, ...)
{
  va_list ap;

  unresolve++;
  va_start (ap, fmt);
  vsnprintf (buffer, sizeof (buffer), fmt, ap);
  va_end (ap);
  printf ("\tUNRESOLVED: %s\n", buffer);
  wait ();
}

static inline void
note (const char* fmt, ...)
{
  va_list ap;

  va_start (ap, fmt);
  vsnprintf (buffer, sizeof (buffer), fmt, ap);
  va_end (ap);
  printf ("\tNOTE: %s\n", buffer);
  wait ();
}

static inline void
totals (void)
{
  printf ("\nTotals:\n");
  printf ("\t#passed:\t\t%d\n", passed);
  printf ("\t#real failed:\t\t%d\n", failed);
  if (xfailed)
    printf ("\t#expected failures:\t\t%d\n", xfailed);
  if (untest)
    printf ("\t#untested:\t\t%d\n", untest);
  if (unresolve)
    printf ("\t#unresolved:\t\t%d\n", unresolve);
}

#ifdef __cplusplus

#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>

const char *outstate_list[] = {
  "FAILED: ", "PASSED: ", "UNTESTED: ", "UNRESOLVED: ", "XFAILED: ", "XPASSED: "
};

const char ** outstate = outstate_list;

enum teststate { FAILED, PASSED, UNTESTED, UNRESOLVED, XFAILED, XPASSED} laststate;

class TestState {
 private:
  teststate laststate;
  std::string lastmsg;
 public:
  TestState (void)
    {
      passed = 0;
      failed = 0;
      untest = 0;
      xpassed = 0;
      xfailed = 0;
      unresolve = 0;
    }

  ~TestState (void) { totals(); }

  void testrun (bool b, std::string s)
    {
      if (b)
	pass (s);
      else
	fail (s);
    }

    void pass (std::string s)
      {
	passed++;
	laststate = PASSED;
	lastmsg = s;
	std::cout << "\t" << outstate[PASSED] << s << std::endl;
      }

    void pass (const char *c)
      {
	std::string s = c;
	pass (s);
      }

    void xpass (std::string s)
      {
	xpassed++;
	laststate = PASSED;
	lastmsg = s;
	std::cout << "\t" << outstate[XPASSED] << s << std::endl;
      }

    void xpass (const char *c)
      {
	std::string s = c;
	xpass (s);
      }

    void fail (std::string s)
      {
	failed++;
	laststate = FAILED;
	lastmsg = s;
	std::cout << "\t" << outstate[FAILED] << s << std::endl;
      }

    void fail (const char *c)
      {
	std::string s = c;
	fail (s);
      }

    void xfail (std::string s)
      {
	xfailed++;
	laststate = XFAILED;
	lastmsg = s;
	std::cout << "\t" << outstate[XFAILED] << s << std::endl;
      }

    void xfail (const char *c)
      {
	std::string s = c;
	xfail (s);
      }

    void untested (std::string s)
      {
	untest++;
	laststate = UNTESTED;
	lastmsg = s;
	std::cout << "\t" << outstate[UNTESTED] << s << std::endl;
      }

    void untested (const char *c)
      {
	std::string s = c;
	untested (s);
      }

    void unresolved (std::string s)
      {
	unresolve++;
	laststate = UNRESOLVED;
	lastmsg = s;
	std::cout << "\t" << outstate[UNRESOLVED] << s << std::endl;
      }

    void unresolved (const char *c)
      {
	std::string s = c;
	unresolved (s);
      }

    void totals (void)
      {
	std::cout << "\t#passed:\t\t" << passed << std::endl;
	std::cout << "\t#real failed:\t\t" << failed << std::endl;
	if (xfailed)
	  std::cout << "\t#expected failures:\t\t" << xfailed << std::endl;
	if (xpassed)
	  std::cout << "\t#unexpected passes:\t\t" << xpassed << std::endl;
	if (untest)
	  std::cout << "\t#untested:\t\t" << untest << std::endl;
	if (unresolve)
	  std::cout << "\t#unresolved:\t\t" << unresolve << std::endl;
      }

    // This is so this class can be printed in an ostream.
    friend std::ostream & operator << (std::ostream &os, TestState& t)
      {
	return os << "\t" << outstate[t.laststate] << t.lastmsg ;
      }

    int GetState (void) { return laststate; }
    std::string GetMsg (void) { return lastmsg; }
};

#endif /* __cplusplus */
#endif /* _DEJAGNU_H_ */
