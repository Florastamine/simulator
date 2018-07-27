#ifdef _WIN32
  #define UUID_EXPORT __declspec (dllexport)
#else
  #define UUID_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

UUID_EXPORT int luaopen_uuid (lua_State *L);

#ifdef __cplusplus
}
#endif
