------------------------------------------------------------------------------
--                                                                          --
--                         GNAT LIBRARY COMPONENTS                          --
--                                                                          --
--                       A D A . C O N T A I N E R S .                      --
--        R E S R I C T E D  _ D O U B L Y _ L I N K E D _ L I S T S        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 2004-2007, Free Software Foundation, Inc.         --
--                                                                          --
-- This specification is derived from the Ada Reference Manual for use with --
-- GNAT. The copyright notice above, and the license provisions that follow --
-- apply solely to the  contents of the part following the private keyword. --
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
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
--                                                                          --
-- This unit was originally developed by Matthew J Heaney.                  --
------------------------------------------------------------------------------

with Ada_Containers; use Ada_Containers;

generic
   type Element_Type is private;

   with function "=" (Left, Right : Element_Type)
      return Boolean is <>;

package Ada_Containers_Restricted_Doubly_Linked_Lists is
   pragma Pure;

   type List (Capacity : Count_Type) is tagged limited private;

   type Cursor is private;

   --  Empty_List : constant List;

   No_Element : constant Cursor;

   function "=" (Left, Right : List) return Boolean;

   procedure Assign (Target : in out List; Source : List);

   function Length (Container : List) return Count_Type;

   function Is_Empty (Container : List) return Boolean;

   procedure Clear (Container : in out List);

   function Element (Position : Cursor) return Element_Type;

   procedure Replace_Element
     (Container : in out List;
      Position  : Cursor;
      New_Item  : Element_Type);

   generic
      with procedure Process (Element : Element_Type);
   procedure Generic_Query_Element (Position : Cursor);

   generic
      with procedure Process (Element : in out Element_Type);
   procedure Generic_Update_Element
     (Container : in out List;
      Position  : Cursor);

--     procedure Move
--       (Target : in out List;
--        Source : in out List);

   procedure Insert
     (Container : in out List;
      Before    : Cursor;
      New_Item  : Element_Type;
      Count     : Count_Type := 1);

   procedure Insert
     (Container : in out List;
      Before    : Cursor;
      New_Item  : Element_Type;
      Position  : out Cursor;
      Count     : Count_Type := 1);

   procedure Insert
     (Container : in out List;
      Before    : Cursor;
      Position  : out Cursor;
      Count     : Count_Type := 1);

   procedure Prepend
     (Container : in out List;
      New_Item  : Element_Type;
      Count     : Count_Type := 1);

   procedure Append
     (Container : in out List;
      New_Item  : Element_Type;
      Count     : Count_Type := 1);

   procedure Delete
     (Container : in out List;
      Position  : in out Cursor;
      Count     : Count_Type := 1);

   procedure Delete_First
     (Container : in out List;
      Count     : Count_Type := 1);

   procedure Delete_Last
     (Container : in out List;
      Count     : Count_Type := 1);

   procedure Reverse_Elements (Container : in out List);

   procedure Swap
     (Container : in out List;
      I, J      : Cursor);

   procedure Swap_Links
     (Container : in out List;
      I, J      : Cursor);

--     procedure Splice
--       (Target : in out List;
--        Before : Cursor;
--        Source : in out List);

--     procedure Splice
--       (Target   : in out List;
--        Before   : Cursor;
--        Source   : in out List;
--        Position : in out Cursor);

   procedure Splice
     (Container : in out List;
      Before    : Cursor;
      Position  : in out Cursor);

   function First (Container : List) return Cursor;

   function First_Element (Container : List) return Element_Type;

   function Last (Container : List) return Cursor;

   function Last_Element (Container : List) return Element_Type;

   function Next (Position : Cursor) return Cursor;

   procedure Next (Position : in out Cursor);

   function Previous (Position : Cursor) return Cursor;

   procedure Previous (Position : in out Cursor);

   function Find
     (Container : List;
      Item      : Element_Type;
      Position  : Cursor := No_Element) return Cursor;

   function Reverse_Find
     (Container : List;
      Item      : Element_Type;
      Position  : Cursor := No_Element) return Cursor;

   function Contains
     (Container : List;
      Item      : Element_Type) return Boolean;

   function Has_Element (Position : Cursor) return Boolean;

   generic
      with procedure Process (Position : Cursor);
   procedure Generic_Iterate (Container : List);

   generic
      with procedure Process (Position : Cursor);
   procedure Generic_Reverse_Iterate (Container : List);

   generic
      with function "<" (Left, Right : Element_Type) return Boolean is <>;
   package Generic_Sorting is

      function Is_Sorted (Container : List) return Boolean;

      procedure Sort (Container : in out List);

--      procedure Merge (Target, Source : in out List);

   end Generic_Sorting;

private

   subtype Prev_Subtype is Count_Type'Base range -1 .. Count_Type'Last;

   type Node_Type is limited record
      Element : Element_Type;
      Next    : Count_Type;
      Prev    : Prev_Subtype;
   end record;

   type Node_Array is array (Count_Type range <>) of Node_Type;

   type List (Capacity : Count_Type) is tagged limited record
      Nodes  : Node_Array (1 .. Capacity);
      Free   : Count_Type'Base := -1;
      First  : Count_Type := 0;
      Last   : Count_Type := 0;
      Length : Count_Type := 0;
   end record;

   --  Empty_List : constant List := (0, others => <>);

   type List_Access is access constant List;

   type Cursor is record
      Container : List_Access;
      Node      : Count_Type := 0;
   end record;

   No_Element : constant Cursor := (null, 0);

end Ada_Containers_Restricted_Doubly_Linked_Lists;
