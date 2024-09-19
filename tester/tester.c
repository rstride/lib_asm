#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include "libasm.h"
#include "style.h"

#define OK GREEN BOLD "[OK] " END_STYLE
#define KO RED BOLD "[KO] " END_STYLE

#define MSG(str) printf("%s%s 💬 %s %s\n", GREEN, TITLE, str, END_STYLE)

int		_asm, _libc, _libc_err, _asm_err, comp, r, fd, i;
char	*_in, *_duplibc, *_dupasm, _bufasm[4096], _buflibc[4096];
t_list	*tmp;

#define STRLEN_EXP(str) printf("%s\"%s\"%s%s -> expected: %d, got: %d %s", PURPLE, str, RED, THIN, _libc, _asm, END_STYLE);
#define STRLEN(str) _asm = ft_strlen(str); _libc = strlen(str);\
					if (_asm != _libc) {printf(KO); STRLEN_EXP(str);} else printf(OK);

#define STRCPY_EXP(str) printf("%s%sexpected: %s, got: %s %s", RED, THIN, str, _bufasm, END_STYLE);
#define STRCPY(str) ft_strcpy(_bufasm, str); if(strcmp(_bufasm, str) != 0) {printf(KO);\
					STRCPY_EXP(str);} else printf(OK);

#define WRITE_ERR_EXP printf("%s%sexpected: %d - %d, got: %d - %d %s", RED, THIN,\
					_libc_err, _libc, _asm_err, _asm, END_STYLE);
#define WRITE_ERR(fd, str, len) _asm = ft_write(fd, str, len); _asm_err = errno;\
					_libc = write(fd, str, len); _libc_err = errno;\
					if(_libc != _asm || _libc_err != _asm_err) {printf(KO); WRITE_ERR_EXP;}\
					else printf(OK);

#define WRITE_EXP printf("%s%sexpected: %s, got: %s %s", RED, THIN, _buflibc, _bufasm, END_STYLE);
#define WRITE(str) fd = open("/tmp/tmp", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | \
					S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH); if(fd < 0)return (-1);\
					_asm = ft_write(fd, str, strlen(str));\
					close(fd); fd = open("/tmp/tmp", O_RDONLY); r = read(fd, _bufasm, 4096);\
					if (r >= 0) _bufasm[r] = 0; close(fd); fd = open("/tmp/tmp", O_WRONLY | O_CREAT \
					| O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);\
					if(fd < 0)return (-1); _libc = write(fd, str, strlen(str));\
					close(fd); fd = open("/tmp/tmp", O_RDONLY); r = read(fd, _buflibc, 4096);\
					if (r >= 0) _buflibc[r] = 0; close(fd); comp = strcmp(_bufasm, _buflibc);\
					if (comp != 0){printf(KO); WRITE_EXP;} else printf(OK);

#define READ_ERR_EXP printf("%s%sexpected: %d - %d, got: %d - %d %s", RED, THIN,\
					_libc_err, _libc, _asm_err, _asm, END_STYLE);
#define READ_ERR(fd, str, len) _asm = ft_read(fd, str, len); _asm_err = errno;\
					_libc = read(fd, str, len); _libc_err = errno;\
					if(_libc != _asm || _libc_err != _asm_err) {printf(KO); READ_ERR_EXP;}\
					else printf(OK);

#define READ_EXP printf("%s%sexpected: %s, got: %s %s", RED, THIN, _buflibc, _bufasm, END_STYLE);
#define READ(str) fd = open("/tmp/tmp", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | \
					S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH); if(fd < 0)return (-1);\
					_asm = write(fd, str, strlen(str));\
					close(fd); fd = open("/tmp/tmp", O_RDONLY); r = ft_read(fd, _bufasm, 4096);\
					if (r >= 0) _bufasm[r] = 0; close(fd); fd = open("/tmp/tmp", \
					O_RDONLY); r = read(fd, _buflibc, 4096);\
					if (r >= 0) _buflibc[r] = 0; close(fd); comp = strcmp(_bufasm, _buflibc);\
					if (comp != 0){printf(KO); READ_EXP;} else printf(OK);

#define STRDUP_EXP printf("%s%sexpected: %s, got: %s %s", RED, THIN, _duplibc, _dupasm, END_STYLE);
#define STRDUP(str) _in = strdup(str); _duplibc = strdup(_in); _dupasm = ft_strdup(_in);\
					_in[0] = 0; if(strcmp(_duplibc, _dupasm) != 0) {printf(KO);\
					STRDUP_EXP;} else printf(OK); free(_in); free(_duplibc); free(_dupasm);

#define STRCMP_EXP(s1, s2) printf("%s\"%s\" - \"%s\"%s%s -> expected: %d, got: %d %s",\
					PURPLE, s1, s2, RED, THIN, _libc, _asm, END_STYLE);
#define STRCMP(s1, s2) _libc = strcmp(s1, s2); _asm = ft_strcmp(s1, s2);\
					if ((_libc < 0 && _asm < 0) || (_libc > 0 && _asm >0)\
					|| (_libc == 0 && _asm == 0)) printf(OK); else\
					{printf(KO); STRCMP_EXP(s1, s2);}

int	ft_is_in_base(char c, char *base)
{
	int	i;

	i = 0;
	while (base[i]) {
		if (base[i] == c)
			return (i);
		i++;
	}
	return (-1);
}

int	ft_get_number(char *str, char *base)
{
	int	minus_sign;
	int	value;

	minus_sign = 0;
	value = 0;
	while (*str == ' ' || *str == '\f' || *str == '\n'
		|| *str == '\r' || *str == '\t' || *str == '\v')
		str++;
	while (*str == '-' || *str == '+') {
		if (*str == '-')
			minus_sign++;
		str++;
	}
	while (ft_is_in_base(*str, base) != -1) {
		value = value * strlen(base) + ft_is_in_base(*str, base);
		str++;
	}
	return (value * -((minus_sign % 2) * 2 - 1));
}

int	libc_atoi_base(char *str, char *base)
{
	int	i;
	int	j;
	int	error;

	i = 0;
	error = 0;
	if (strlen(base) < 2)
		error = 1;
	while (i < (int)strlen(base) && error == 0) {
		if (base[i] == '-' || base[i] == '+' || base[i] == ' ' || base[i] == '\f'
			 || base[i] == '\n' || base[i] == '\r' || base[i] == '\t' || base[i] == '\v')
			error = 1;
		j = i + 1;
		while (j < (int)strlen(base)) {
			if (base[i] == base[j])
				error = 1;
			j++;
		}
		i++;
	}
	if (error == 0)
		return (ft_get_number(str, base));
	return (0);
}

int main () {
	MSG("ft_strlen");
	STRLEN("");
	STRLEN("1");
	STRLEN("02");
	STRLEN("cinq!");
	STRLEN("!#@$%$#@!");
	STRLEN("\1\2\3\4\5\6\7ok");
	STRLEN("\42\264\128ok");
	STRLEN("avec des \0 en plein milieu");
	STRLEN("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do \
eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed odio morbi quis \
commodo odio aenean sed. Neque ornare aenean euismod elementum nisi quis \
eleifend. Fermentum et sollicitudin ac orci phasellus egestas tellus rutrum \
tellus. Aliquet nec ullamcorper sit amet risus nullam eget felis. Eu nisl nunc \
mi ipsum faucibus vitae. Eu consequat ac felis donec et odio pellentesque diam. \
Facilisi cras fermentum odio eu feugiat pretium nibh ipsum consequat. Tortor \
pretium viverra suspendisse potenti. Pulvinar neque laoreet suspendisse interdum \
consectetur libero id faucibus nisl.");
	printf("\n\n");
	
	MSG("ft_strcpy");
	STRCPY("");
	STRCPY("1");
	STRCPY("02");
	STRCPY("cinq!");
	STRCPY("!#@$%$#@!");
	STRCPY("\1\2\3\4\5\6\7ok");
	STRCPY("\42\264\128ok");
	STRCPY("avec des \0 en plein milieu");
	STRCPY("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do \
eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed odio morbi quis \
commodo odio aenean sed. Neque ornare aenean euismod elementum nisi quis \
eleifend. Fermentum et sollicitudin ac orci phasellus egestas tellus rutrum \
tellus. Aliquet nec ullamcorper sit amet risus nullam eget felis. Eu nisl nunc \
mi ipsum faucibus vitae. Eu consequat ac felis donec et odio pellentesque diam. \
Facilisi cras fermentum odio eu feugiat pretium nibh ipsum consequat. Tortor \
pretium viverra suspendisse potenti. Pulvinar neque laoreet suspendisse interdum \
consectetur libero id faucibus nisl.");
	printf("\n\n");

	MSG("ft_strcmp");
	STRCMP("", "");
	STRCMP("1", "1");
	STRCMP("02", "02");
	STRCMP("cinq!", "cinq!");
	STRCMP("!#@$%$#@!", "!#@$%$#@!");
	STRCMP("\1\2\3\4\5\6\7ok", "\1\2\3\4\5\6\7ok");
	STRCMP("\42\264\128ok", "\42\264\128");
	STRCMP("avec des \0 en plein milieu", "avec des \0 en plein milieu");
	STRCMP("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do \
eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed odio morbi quis \
commodo odio aenean sed. Neque ornare aenean euismod elementum nisi quis \
eleifend. Fermentum et sollicitudin ac orci phasellus egestas tellus rutrum \
tellus. Aliquet nec ullamcorper sit amet risus nullam eget felis. Eu nisl nunc \
mi ipsum faucibus vitae. Eu consequat ac felis donec et odio pellentesque diam. \
Facilisi cras fermentum odio eu feugiat pretium nibh ipsum consequat. Tortor \
pretium viverra suspendisse potenti. Pulvinar neque laoreet suspendisse interdum \
consectetur libero id faucibus nisl.", "Lorem ipsum dolor sit amet, consectetur \
adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. \
Sed odio morbi quis commodo odio aenean sed. Neque ornare aenean euismod elementum \
nisi quis eleifend. Fermentum et sollicitudin ac orci phasellus egestas tellus rutrum \
tellus. Aliquet nec ullamcorper sit amet risus nullam eget felis. Eu nisl nunc \
mi ipsum faucibus vitae. Eu consequat ac felis donec et odio pellentesque diam. \
Facilisi cras fermentum odio eu feugiat pretium nibh ipsum consequat. Tortor \
pretium viverra suspendisse potenti. Pulvinar neque laoreet suspendisse interdum \
consectetur libero id faucibus nisl.");
	STRCMP("", "r");
	STRCMP("b", "1");
	STRCMP("02", "f02");
	STRCMP("02rf", "02");
	STRCMP("cinq!", "cifnq!");
	STRCMP("!#@$%$d#@!", "!#@$%$#@!");
	STRCMP("\5\2\3\4\5\6\7ok", "\1\2\3\4\5\6\7ok");
	STRCMP("\42\264\128ok", "\49\264\128");
	STRCMP("avec des \0 en plein milieu", "avec des \0 en ilein milieu");
	printf("\n\n");

	MSG("ft_write");
	WRITE_ERR(-2, "ok", 2);
	WRITE_ERR(1, NULL, 7);
	WRITE_ERR(-234342, "ok", 2);
	WRITE_ERR(23, "ok", 2);
	WRITE_ERR(245453, "", 1);
	WRITE("salut");
	WRITE("");
	WRITE("1");
	WRITE("02");
	WRITE("cinq!");
	WRITE("!#@$%$#@!");
	WRITE("\1\2\3\4\5\6\7ok");
	WRITE("\42\264\128ok");
	WRITE("avec des \0 en plein milieu");
	WRITE("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do \
eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed odio morbi quis \
commodo odio aenean sed. Neque ornare aenean euismod elementum nisi quis \
eleifend. Fermentum et sollicitudin ac orci phasellus egestas tellus rutrum \
tellus. Aliquet nec ullamcorper sit amet risus nullam eget felis. Eu nisl nunc \
mi ipsum faucibus vitae. Eu consequat ac felis donec et odio pellentesque diam. \
Facilisi cras fermentum odio eu feugiat pretium nibh ipsum consequat. Tortor \
pretium viverra suspendisse potenti. Pulvinar neque laoreet suspendisse interdum \
consectetur libero id faucibus nisl.");
	printf("\n\n");
	
	MSG("ft_read");
	char buf[4096];
	READ_ERR(-1, buf, 3);
	READ_ERR(4, NULL, 7);
	READ_ERR(-234342, buf, 57);
	READ_ERR(23, buf, 23);
	READ_ERR(245453, buf, 1);
	READ("salut");
	READ("");
	READ("1");
	READ("02");
	READ("cinq!");
	READ("!#@$%$#@!");
	READ("\1\2\3\4\5\6\7ok");
	READ("\42\264\128ok");
	READ("avec des \0 en plein milieu");
	READ("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do \
eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed odio morbi quis \
commodo odio aenean sed. Neque ornare aenean euismod elementum nisi quis \
eleifend. Fermentum et sollicitudin ac orci phasellus egestas tellus rutrum \
tellus. Aliquet nec ullamcorper sit amet risus nullam eget felis. Eu nisl nunc \
mi ipsum faucibus vitae. Eu consequat ac felis donec et odio pellentesque diam. \
Facilisi cras fermentum odio eu feugiat pretium nibh ipsum consequat. Tortor \
pretium viverra suspendisse potenti. Pulvinar neque laoreet suspendisse interdum \
consectetur libero id faucibus nisl.");
	printf("\n\n");

	MSG("ft_strdup");
	STRDUP("salut");
	STRDUP("");
	STRDUP("1");
	STRDUP("02");
	STRDUP("cinq!");
	STRDUP("!#@$%$#@!");
	STRDUP("\1\2\3\4\5\6\7ok");
	STRDUP("\42\264\128ok");
	STRDUP("avec des \0 en plein milieu");
	STRDUP("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do \
eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed odio morbi quis \
commodo odio aenean sed. Neque ornare aenean euismod elementum nisi quis \
eleifend. Fermentum et sollicitudin ac orci phasellus egestas tellus rutrum \
tellus. Aliquet nec ullamcorper sit amet risus nullam eget felis. Eu nisl nunc \
mi ipsum faucibus vitae. Eu consequat ac felis donec et odio pellentesque diam. \
Facilisi cras fermentum odio eu feugiat pretium nibh ipsum consequat. Tortor \
pretium viverra suspendisse potenti. Pulvinar neque laoreet suspendisse interdum \
consectetur libero id faucibus nisl.");
	printf("\n\n");
	return (0);
}
