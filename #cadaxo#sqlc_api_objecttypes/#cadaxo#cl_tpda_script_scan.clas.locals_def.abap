*"* use this source file for any type declarations (class
*"* definitions, interfaces or data types) you need for method
*"* implementation or private method's signature
types: begin of ty_keyword_class,
        keyword type string,
        subkey  type string,
        subkey2 type string,
        class   type string,
       end of ty_keyword_class.
types: ty_it_keyword_class type standard TABLE OF ty_keyword_class with non-UNIQUE KEY keyword subkey subkey2.
