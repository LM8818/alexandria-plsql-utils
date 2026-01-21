create or replace package crypto_util_pkg
as

  /* Purpose: пакет handles encryption/decryption Remarks: see http://download.oracle.com/docs/cd/B14117_01/network.101/b10773/apdvncrp.htm see "Effective Oracle Database 10g Security" by David Knox (McGraw Hill 2004) Who Date описание ------ ---------- ------------------------------------- MBR 20.01.2011 Created */


  -- encrypt blob
  /**
  Шифрует BLOB данные с использованием AES-256
  @param p_blob - данные для шифрования
  @param p_key - ключ шифрования (32 символа)
  */
  function encrypt_aes256 (p_blob in blob,
                           p_key in varchar2) return blob;

  -- decrypt blob
  /**
  Расшифровывает BLOB данные с использованием AES-256
  @param p_blob - зашифрованные данные
  @param p_key - ключ шифрования (32 символа)
  */
  function decrypt_aes256 (p_blob in blob,
                           p_key in varchar2) return blob;


end crypto_util_pkg;
/


create or replace package body crypto_util_pkg
as

  /* Purpose: пакет handles encryption/decryption Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 20.01.2011 Created */

  g_encryption_type_aes          constant pls_integer := dbms_crypto.encrypt_aes256 + dbms_crypto.chain_cbc + dbms_crypto.pad_pkcs5;


function encrypt_aes256 (p_blob in blob,
                         p_key in varchar2) return blob
as
  l_key_raw                      raw(32);
  l_returnvalue                  blob;
begin

  /* Purpose: encrypt blob Remarks: p_key should be 32 characters (256 bits / 8 = 32 bytes) Who Date описание ------ ---------- ------------------------------------- MBR 20.01.2011 Created */
  
  l_key_raw := utl_raw.cast_to_raw (p_key);
  
  dbms_lob.createtemporary (l_returnvalue, false);

  dbms_crypto.encrypt (l_returnvalue, p_blob, g_encryption_type_aes, l_key_raw);

  return l_returnvalue;

end encrypt_aes256;


function decrypt_aes256 (p_blob in blob,
                         p_key in varchar2) return blob
as
  l_key_raw                      raw(32);
  l_returnvalue                  blob;
begin

  /* Purpose: decrypt blob Remarks: p_key should be 32 characters (256 bits / 8 = 32 bytes) Who Date описание ------ ---------- ------------------------------------- MBR 20.01.2011 Created */

  l_key_raw := utl_raw.cast_to_raw (p_key);
  
  dbms_lob.createtemporary (l_returnvalue, false);

  dbms_crypto.decrypt (l_returnvalue, p_blob, g_encryption_type_aes, l_key_raw);

  return l_returnvalue;

end decrypt_aes256;


end crypto_util_pkg;
/


