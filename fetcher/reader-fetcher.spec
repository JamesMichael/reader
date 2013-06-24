Name:		reader-fetcher
Version:	0.2
Release:	1%{?dist}
Summary:	Reader Feed Fetcher

Group:		Applications/Internet
License:	Public Domain
URL:		https://github.com/JamesMichael/reader
Source0:	%{name}-%{version}-%{release}.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
BuildArch:	noarch

Requires:	perl(DateTime)
Requires:	perl(HTTP::Request::Common)
Requires:	perl(LWP::UserAgent)
Requires:	perl(Readonly)

Requires:	reader-tools

%description
Fetches RSS feeds


%prep
%setup -q -n fetcher


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
install -m 0644 etc/crontab %{buildroot}/etc/cron.d/fetcher


%clean
rm -rf %{buildroot}


%files
%defattr(-,reader,reader,-)

/opt/reader/bin/fetcher
/opt/reader/lib/Reader/Fetcher.pm

/etc/cron.d/fetcher


%changelog
* Mon Jul 24 2013 <James Michael> - 0.2-1
- Add cron job

* Thu Jul 20 2013 <James Michael> - 0.1-1
- Initial fetcher package
