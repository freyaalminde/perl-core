void perlcore_sys_init();
void *perlcore_init();
void perlcore_deinit();
void perlcore_sys_term();
void *perlcore_eval_pv(const char* script, int croak_on_error);
int perlcore_err();
char *perlcore_errstr();

void *perlcore_get_sv(const char *name, int add);
int perlcore_svok(void *vp);
int perlcore_svtrue(void *vp);
unsigned long perlcore_svuv(void *vp);
long perlcore_sviv(void *vp);
double perlcore_svnv(void *vp);
char *perlcore_svpv(void *vp);
void perlcore_undef(void *vp);
void perlcore_setuv(void *vp, unsigned long uv);
void perlcore_setiv(void *vp, long iv);
void perlcore_setnv(void *vp, double nv);
void perlcore_setpv(void *vp, const char *pv);

void *perlcore_get_av(const char *name, int add);
int perlcore_av_len(void *vp);
void *perlcore_av_fetch(void *vp, int key, int add);
void *perlcore_av_delete(void *vp, int key);

void *perlcore_get_hv(const char *name, int add);
void *perlcore_hv_fetchs(void *vp, const char *key, int add);
int perlcore_hv_iterinit(void *vp);
void *perlcore_hv_iternext(void *vp);
char *perlcore_hv_iterkey(void *vp);
void *perlcore_hv_iterval(void *vp);
void *perlcore_hv_delete(void *vp, const char *key);

char *perlcore_reftype(void *vp);
void *perlcore_deref(void *vp);
