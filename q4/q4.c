#include <dlfcn.h>
#include <stdio.h>

typedef int (*op_fn_t)(int, int);

int main(void) {
	char op[6];
	int num1, num2;

	while (scanf("%5s %d %d", op, &num1, &num2) == 3) {
		char libname[16];
		void *handle;
		op_fn_t fn;

		snprintf(libname, sizeof(libname), "./lib%s.so", op);
		handle = dlopen(libname, RTLD_LAZY);
		if (handle == NULL) {
			continue;
		}

		fn = (op_fn_t)dlsym(handle, op);
		if (fn != NULL) {
			int result = fn(num1, num2);
			printf("%d\n", result);
		}

		dlclose(handle);
	}

	return 0;
}
