#ifdef _WIN32
  #define EXPORT __declspec (dllexport)
#else
  #define EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

EXPORT int luaopen_uuid (lua_State *L);

#ifdef __cplusplus
}
#endif
