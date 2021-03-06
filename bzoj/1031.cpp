#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
const int maxn = 200005;
int wa[maxn],wb[maxn],wv[maxn],wss[maxn];
int cmp(int *r,int a,int b,int l)
{return r[a]==r[b]&&r[a+l]==r[b+l];}
void da(int *r,int *sa,int n,int m)
{
    int i,j,p,*x=wa,*y=wb,*t;
    for(i=0;i<m;i++) wss[i]=0;
    for(i=0;i<n;i++) wss[x[i]=r[i]]++;
    for(i=1;i<m;i++) wss[i]+=wss[i-1];
    for(i=n-1;i>=0;i--) sa[--wss[x[i]]]=i;
    for(j=1,p=1;p<n;j*=2,m=p)
    {
        for(p=0,i=n-j;i<n;i++) y[p++]=i;
        for(i=0;i<n;i++) if(sa[i]>=j) y[p++]=sa[i]-j;
        for(i=0;i<n;i++) wv[i]=x[y[i]];
        for(i=0;i<m;i++) wss[i]=0;
        for(i=0;i<n;i++) wss[wv[i]]++;
        for(i=1;i<m;i++) wss[i]+=wss[i-1];
        for(i=n-1;i>=0;i--) sa[--wss[wv[i]]]=y[i];
        for(t=x,x=y,y=t,p=1,x[sa[0]]=0,i=1;i<n;i++)
            x[sa[i]]=cmp(y,sa[i-1],sa[i],j)?p-1:p++;
    }
    return;
}

char s[maxn];
int r[maxn], sa[maxn], rank[maxn];

int main() {
    scanf("%s",s); int n=strlen(s);
    for (int i=0; i<n; ++i) r[i]=s[i];
    for (int i=0; i<n; ++i) r[i+n]=s[i];
    r[n*2]=0; da(r,sa,n*2+1,255);
    for (int i=0; i<n*2+1; ++i) if (sa[i]<n) printf("%c",r[sa[i]+n-1]);
    //for (int i=0; i<n; ++i) printf("%d ", rank[i]);
    printf("\n");
    return 0;
}