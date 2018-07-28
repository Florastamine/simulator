#ifdef _WIN32
  #define ZIP_EXPORT __declspec (dllexport)
#else
  #define ZIP_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

ZIP_EXPORT int luaopen_zip (lua_State *L);

#ifdef __cplusplus
}
#endif
