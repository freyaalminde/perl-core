@import Foundation;

static NSString *bundleName = @"perl-core_CPerlCore.bundle";

@interface BundleFinder : NSObject
@end

@implementation BundleFinder
@end

#define PERL_DARWIN 1
#include <EXTERN.h>
#include <perl.h>

EXTERN_C void xs_init (pTHX);
EXTERN_C void boot_DynaLoader (pTHX_ CV* cv);
EXTERN_C void xs_init(pTHX) {
  char *file = __FILE__;
  dXSUB_SYS;
  
  /* DynaLoader is a special case */
//  newXS("DynaLoader::boot_DynaLoader", boot_DynaLoader, file);
}

// TODO: allow multiple interpreters
static PerlInterpreter *my_perl = NULL;

void perlcore_sys_init() {
  NSString *resourcePath = [[NSBundle bundleForClass:BundleFinder.class] resourcePath];
  NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
  NSString *modulesPath = [bundlePath stringByAppendingPathComponent:@"Contents/Resources/modules"];
  setenv("PERLLIB", [modulesPath cStringUsingEncoding:NSUTF8StringEncoding], true);
  
  int    noc = 0;
  char **nov = NULL;
  PERL_SYS_INIT3(&noc, &nov, &nov);
}

void *perlcore_init() {
  if (my_perl != NULL) {
    fprintf(stderr, "%s\n", "Multiple perl instance is not supported yet\n");
    exit(-1);
  }
  char *embedding[] = { "", "-e", "1" };
  my_perl = perl_alloc();
  perl_construct(my_perl);
  perl_parse(my_perl, xs_init, 3, embedding, NULL);
  PL_exit_flags |= PERL_EXIT_DESTRUCT_END;
  perl_run(my_perl);
  return (void *)my_perl;
}

void perlcore_deinit() {
  perl_destruct(my_perl);
  perl_free(my_perl);
  my_perl = NULL;
}

void perlcore_sys_term() {
  if (my_perl != NULL) perlcore_deinit();
  PERL_SYS_TERM();
}

void *perlcore_eval_pv(const char* script, I32 croak_on_error) {
  return (void *)eval_pv(script, croak_on_error);
}

int perlcore_err() {
  return SvTRUE(ERRSV);
}

char *perlcore_errstr() {
  return SvPVx_nolen(ERRSV);
}

void *perlcore_get_sv(const char *name, int add) {
  return (void *)get_sv(name, add ? GV_ADD : 0);
}

// MARK: - Scalar Value Getters
int perlcore_svok(void *vp) {
  return SvOK((SV *)vp);
}

int perlcore_svtrue(void *vp) {
  return SvTRUE((SV *)vp);
}

unsigned long perlcore_svuv(void *vp) {
  return (unsigned long)SvUV((SV *)vp);
}

long perlcore_sviv(void *vp) {
  return (long)SvIV((SV *)vp);
}
double perlcore_svnv(void *vp) {
  return (double)SvNV((SV *)vp);
}
char *perlcore_svpv(void *vp) {
  return SvPV_nolen((SV *)vp);
}

// MARK: - Scalar Values
void perlcore_undef(void *vp) {
  sv_setsv_mg((SV *)vp, &PL_sv_undef);
}
void perlcore_setuv(void *vp, unsigned long uv) {
  sv_setuv_mg((SV *)vp, uv);
}
void perlcore_setiv(void *vp, long iv) {
  sv_setiv_mg((SV *)vp, iv);
}
void perlcore_setnv(void *vp, double nv) {
  sv_setnv_mg((SV *)vp, nv);
}
void perlcore_setpv(void *vp, const char *pv) {
  sv_setpv_mg((SV *)vp, pv);
}

// MARK: - Array Values
void *perlcore_get_av(const char *name, int add) {
  return (void *)get_av(name, add ? GV_ADD : 0);
}
int perlcore_av_len(void *vp){
  return av_len((AV *)vp);
}
void *perlcore_av_fetch(void *vp, int key, int add) {
  SV **svp = av_fetch((AV *)vp, key, add ? GV_ADD : 0);
  return svp ? (void *)*svp : NULL;
}
void *perlcore_av_delete(void *vp, int key) {
  return (void *)av_delete((AV *)vp, key, 0);
}

// MARK: - Hash Values
void *perlcore_get_hv(const char *name, int add) {
  return (void *)get_hv(name, add ? GV_ADD : 0);
}
int perlcore_hv_iterinit(void *vp) {
  return hv_iterinit((HV *)vp);
}
void *perlcore_hv_fetchs(void *vp, const char *key, int add) {
  SV **svp = hv_fetch((HV *)vp, key, (int)strlen(key),
                      add ? GV_ADD : 0);
  return svp ? (void *)*svp : NULL;
}
void *perlcore_hv_iternext(void *vp) {
  return (void *)hv_iternext((HV *)vp);
}
char *perlcore_hv_iterkey(void *vp) {
  SV *ksv = hv_iterkeysv((HE *)vp);
  return SvPV_nolen(ksv);
}
void *perlcore_hv_iterval(void *vp) {
  return HeVAL((HE *)vp);
}
void *perlcore_hv_delete(void *vp, const char *key) {
  return (void *)hv_delete((HV *)vp, key, (int)strlen(key), 0);
}

// MARK: - Reference Types
char *perlcore_reftype(void *vp) {
  SvGETMAGIC((SV *)vp);
  if (SvROK((SV *)vp)) {
    return (char *)sv_reftype(SvRV((SV *)vp), 0);
  } else {
    return "";
  }
}
void *perlcore_deref(void *vp) {
  if (SvROK((SV *)vp)) {
    return (void *)SvRV((SV *)vp);
  } else {
    return NULL;
  }
}
