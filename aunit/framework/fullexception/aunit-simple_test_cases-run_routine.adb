------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--          A U N I T . T E S T _ C A S E S . R U N _ R O U T I N E         --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                                                                          --
--                    Copyright (C) 2006-2009, AdaCore                      --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT;  see file COPYING.  If not, write --
-- to  the  Free Software Foundation,  51  Franklin  Street,  Fifth  Floor, --
-- Boston, MA 02110-1301, USA.                                              --
--                                                                          --
-- GNAT is maintained by AdaCore (http://www.adacore.com)                   --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Exceptions;          use Ada.Exceptions;
with AUnit.Time_Measure;
with GNAT.Traceback.Symbolic; use GNAT.Traceback.Symbolic;

separate (AUnit.Simple_Test_Cases)

--  Version for run-time libraries that support exception handling
procedure Run_Routine
  (Test    : access Test_Case'Class;
   Options :        AUnit_Options;
   R       : in out Result'Class;
   Outcome :    out Status)
is
   Unexpected_Exception : Boolean := False;
   Time : Time_Measure.Time := Time_Measure.Null_Time;

   use Failure_Lists;
   use Time_Measure;

begin

   --  Reset failure list to capture failed assertions for one routine

   Clear (Test.Failures);

   begin
      if Options.Test_Case_Timer then
         Start_Measure (Time);
      end if;

      Run_Test (Test.all);

      if Options.Test_Case_Timer then
         Stop_Measure (Time);
      end if;

   exception
      when Assertion_Error =>
         if Options.Test_Case_Timer then
            Stop_Measure (Time);
         end if;

      when E : others =>
         if Options.Test_Case_Timer then
            Stop_Measure (Time);
         end if;

         Unexpected_Exception := True;
         Add_Error
           (R,
            Name (Test.all),
            Routine_Name (Test.all),
            Error => (Exception_Name    => Format (Exception_Name (E)),
                      Exception_Message => Format (Exception_Message (E)),
                      Traceback         => Format (Symbolic_Traceback (E))),
            Elapsed => Time);
   end;

   if not Unexpected_Exception and then Is_Empty (Test.Failures) then
      Outcome := Success;
      Add_Success (R, Name (Test.all), Routine_Name (Test.all), Time);
   else
      Outcome := Failure;
      declare
         C : Cursor := First (Test.Failures);
      begin
         while Has_Element (C) loop
            Add_Failure (R,
                         Name (Test.all),
                         Routine_Name (Test.all),
                         Element (C),
                         Time);
            Next (C);
         end loop;
      end;
   end if;

end Run_Routine;
