Name:		reader-parser
Version:	0.1
Release:	1%{?dist}
Summary:	Reader Feed Parser

Group:		Applications/Internet
License:	Public Domain
URL:		https://github.com/JamesMichael/reader
Source0:	%{name}-%{version}-%{release}.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
BuildArch:	noarch

Requires:	reader-model

%description
Parses RSS feeds


%prep
%setup -q -n parser


%build
#%%configure


%install
rm -rf %{buildroot}

install -m 0755 -d %{buildroot}/opt/reader/bin/
install -m 0755 bin/* %{buildroot}/opt/reader/bin

find lib -type d -print0 \
    | xargs -0 -I@ install -m 0755 -d %{buildroot}/opt/reader/@

find lib -type f -name '*.pm' -print0 \
    | xargs -0 -I@ install -m 0644 @ %{buildroot}/opt/reader/@

install -m 0755 -d %{buildroot}/etc/cron.d
install -m 0755 etc/crontab %{buildroot}/etc/cron.d/parser


%clean
rm -rf %{buildroot}


%files
%defattr(-,reader,reader,-)

/opt/reader/bin/parser
/opt/reader/lib/Reader/Parser.pm
/opt/reader/lib/Reader/Parser/Atom.pm
/opt/reader/lib/Reader/Parser/RSS.pm

%attr(-,root,root) /etc/cron.d/parser


%changelog
* Mon Jul 24 2013 <James Michael> - 0.1-1
- Initial parser package
