create or replace FUNCTION encrypted_password(username IN VARCHAR2,
   plaintext_password IN VARCHAR2)
RETURN RAW
IS
   string_for_md5 VARCHAR2(120);
BEGIN
   if username is not null and plaintext_password is not null then   
     string_for_md5 := UPPER(username) || UPPER(plaintext_password);
      RETURN DBMS_OBFUSCATION_TOOLKIT.MD5(
      INPUT => UTL_RAW.CAST_TO_RAW(string_for_md5));
   else
    return null;
   end if;
END;




 
begin
  DBMS_OUTPUT.PUT_LINE(encrypted_password('login2','password1'));
end;
/