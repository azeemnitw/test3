select * from emp;
select * from dept;
select distinct job from emp;
select * from emp order by deptno asc,job desc;
select * from emp where job like '%manager%';
select * from emp where empno like (select mgr from emp);
select * from emp where HIREDATE <('01-jan-81');
select * from emp where job='clerk' or job='analyst' order by job desc;
select * from emp where deptno in (10,20);
select * from emp where 12*bal between 22000 and 45000;
select ename from emp where bal like '%0' and LEN(bal)=4;
select * from emp to_char(hiredate,'mon')='jan';
select * from emp where DEPTNO not in(20);
select * from emp where empno not like '78%';
select * from emp where job like '%clerk%';
select * from dept;
select loc from emp e,dept d where e.ENAME='smith' and e.DEPTNO=d.DEPTNO;
select * from emp e ,dept d where dname in ('accounting','research') and e.DEPTNO=d.deptno;
select * from emp e,dept d where e.DEPTNO (+) = d.deptno;
select * from emp where bal>(select bal from emp where ENAME='blake')
select * from emp w,emp m where w.MGR=m.EMPNO and w.HIREDATE<m.HIREDATE;
select * from salgrade;
select * from emp;
select * from dept
select * from emp e,SALGRADE s where e.bal between s.LOSAL and s.HISAL order by GRADE asc;
select * from emp e ,SALGRADE s where e.bal between s.LOSAL and s.HISAL and s.GRADE in (4,5) and empno in (select empno from emp where e.job in ('manager','analyst'))
select * from emp m,emp w where m.empno = w.mgr =
select * from emp w,emp m where w.mgr=m.empno and w.HIREDATE
select * from emp e,dept d where d.DEPTNO=20 and e.DEPTNO=d.DEPTNO
select * from emp e,dept d where d.DEPTNO=10 and e.DEPTNO=d.DEPTNO
select * from emp e,dept d where d.loc in ('chicago','boston') and e.deptno=d.deptno and e.hiredate<(select hiredate from emp where ename='blake')
select job from emp where deptno=10 and job not in (select job from emp where deptno=20)
select max(sal) from emp
select * from emp e where e.DEPTNO in (select DEPTNO from dept d where d.LOC='chicago') and e.HIREDATE in (select MAX(hiredate) from emp where empno in(select empno from emp e,SALGRADE s where e.sal between s.LOSAL and s.HISAL and s.GRADE=3))
select * from emp where hiredate<(select MAX(hiredate) from emp where MGR in (select empno from emp where ename='king'))
select * from emp where mgr in(select empno from emp where ename='king')
select min(hiredate) from emp e ,salgrade s where e.SAL between s.LOSAL and s.hisal and s.GRADE in (4,5)
select * from emp where HIREDATE in (select min(hiredate) from emp e ,salgrade s where e.SAL between s.LOSAL and s.hisal and s.GRADE in (4,5)) and MGR in (select empno from emp where ename='king')
select * from emp where hiredate in (select min(hiredate) from emp where empno in (select empno from emp e,SALGRADE s where e.sal between s.LOSAL and s.HISAL and s.grade in (4,5))) and mgr in (select empno from emp where ename='king')
select deptno,job,count(*) from emp group by deptno,job;
select * from emp m,emp w where w.mgr=m.EMPNO
select DEPTNO,count(*) from emp group by DEPTNO
select count(*) from emp w,emp m where w.mgr=m.EMPNO group by w.mgr
select deptno,count(*) from emp group by DEPTNO
select s.GRADE,count(*) from emp e,salgrade s where e.SAL between s.losal and s.hisal group by s.grade
select * from dept where deptno in (select deptno from emp group by deptno )
select deptno from emp group by deptno having count(*) in (select max(sum) from emp  group by deptno)
select e.mgr,count(*) from emp e,emp m where e.MGR=m.EMPNO group by e.mgr ;
select * from emp e,emp m where e.mgr=m.empno and e.sal>m.sal
select e.deptno,d.dname,e.ENAME from emp e,DEPT d where e.deptno=d.deptno and e.empno in (select mgr from emp)
select * from emp where mgr=(select empno from emp where ename='jones')
select * from emp where sal =(select max(sal) from emp)
select * from emp
select deptno,count(*) from emp group by DEPTNO having count(*)>3
select * from dept d,emp e where d.DEPTNO=e.DEPTNO group by d.dname
select avg(sal) from emp
select * from emp where sal>(select avg(sal) from emp) and job ='manager'
select * from emp order by sal asc
select * from emp e,emp m where e.mgr=m.empno
select e.ename,e.sal from emp e,SALGRADE s where e.ename='ford' and e.sal between s.LOSAL and s.HISAL and e.SAL=s.HISAL
select ename,deptno,sal from emp where sal in (select max(sal) from emp group by DEPTNO)
select dname from dept where deptno in(select deptno from emp group by DEPTNO having count(*)>3)
select * from emp e,emp m where e.MGR=m.EMPNO and e.sal>m.sal
select * from emp where sal%2=
select m.ENAME from emp e,emp m where m.empno=e.mgr and m.SAL>e.SAL
select * from emp m where m.empno in (select mgr from emp) and m.sal>(select avg(e.sal) from emp e where e.mgr=m.empno)
select * from emp where empno in(select empno from emp where job='manager') and mgr not in(select empno from emp where job='president')
select empno from emp where job='president'
select * from emp where empno in(select mgr from emp) and mgr not in (select empno from emp where job='president')
select * from emp where empno not like '78%'
select dname from dept
select * from emp e,dept d where e.deptno=d.deptno and d.dname in ('accounting','research') order by e.DEPTNO desc
select * from emp e,emp m where e.mgr=m.empno and e.HIREDATE<m.HIREDATE
select ename from emp where job in (select JOB from emp where ENAME in ('smith','allen'))
select max(sal) from emp
select * from emp
select * from dept
select * from salgrade
select * from emp e,salgrade s where e.sal between s.LOSAL and s.HISAL and grade=3

select * from dept
select * from emp  where mgr in(select empno from emp where ename='Jones')

select * from emp where sal in (select max(sal) from emp group by deptno)
select mgr,count(*) from emp group by mgr
select * from emp e,emp m where e.mgr=m.empno and e.sal>m.sal 
select * from emp order by sal desc
select * from emp e where 5>(select count(*) from emp e where e.sal>sal)
select deptno from emp group by deptno having count(*)>3

select empno from emp where job = 'President'

select * from emp where empno in (select empno from emp where job='manager')
select MAX(count(*)) from emp group by deptno
select dname from dept where deptno in(select deptno from emp group by deptno having count(*) in(select MAX(count(*)) from emp group by deptno))
select * from emp e where hiredate in (select hiredate from emp where e.empno <> empno)
select avg(count(*)) from emp group by deptno
select mgr,count(*) from emp group by mgr
select count(*) from emp group by mgr
select * from emp
select sum(count(*)) from emp group by mgr
select deptno,count(*) from emp group by deptno having count(*)=0
select *  from dept where deptno in(select  distinct(deptno) from emp)
select * from emp where len(sal)=4

select concat(ename,' work as',job) as msg from emp where deptno=10

select ename,sal,
       case when sal<=2000 then 'underpaid'
	        when sal>=4000 then 'overpaid'
			else 'ok'
	   end as status
from emp

select * 
      from emp limit 5
select ename,job from emp order by rand() LIMIT 5

select top 5 ename,job from emp order by newid()
select ename,job from emp order by substring(job,len(job)-2,2)
select job from emp
select * from emp order by sal,deptno desc
select top 5 * from emp order by newid()
select ename,sal,comm from emp order by 3 desc


select substring(job,len(job)-2,2) from emp
 
 select ename,sal,comm from(select ename,sal,comm,
        case when comm  IS NULL then 0 else 1 end as is_null
	from emp)x
	order by is_null ,comm desc
select ename,sal,comm from emp order by comm desc nulls last

select ename,sal,job,comm from emp order by case when job='salesman' then comm else sal end

select ename as ename_and_dname ,deptno from emp where deptno=10 union all
select distinct deptno from (select deptno from dept union  select ename from emp)
select * from emp

select e.empno,e.ename,e.job,e.sal,e.deptno from emp e,v where e.ename=v.ename and e.job=v.job and e.sal=v.sal

 select ename,sal,comm from(select ename,sal,comm,
        case when comm  IS NULL then 0 else 1 end as is_null
	from emp)x order by is_null desc,comm desc
select e.ename,e.deptno as emp_deptno ,d.* from dept d left join emp e on (d.deptno=e.DEPTNO)

select * from dept d left join emp e on (d.deptno=e.DEPTNO)
select deptno,sum(distinct sal) as total_sal,sum(bonus) as total_bonus from
(select e.empno,e.ename,e.sal,e.deptno,e.sal*case when eb.type=1 then .1
                                                 when eb.type=2 then 0.2
												 else .3
												 end as bonus
												 from emp e,emp_bonus eb
												 where e.EMPNO=eb.empno)x
												 group by deptno

select (len('HELLO HELLO HELLO')-len(replace('HELLO HELLO HELLO','LL','')))/LEN('LL')as cnt
select ename,replace(ename,'A','') as stripped_1 ,sal,replace(sal,0,'')as stripped2 from emp
select ename from emp order by substring(ename,len(ename)-1,2)
select sal from emp
select avg(cast(replace(sal,'0','') AS int)) from emp
select count(max(sal)) from emp
select * from emp

select salary*months,count(*) where salary*months=(select max(salary*months) from employee

select SUBSTRING(job,1,1) from emp
select ename+left(job,2) as emp_j from emp
select 'HELLO '+job from emp group by job order by job
select right(ename,3) from emp

select ename from emp where left(ename,1) like '%S%'

select (len('hello hello'))-len(replace('hello hello','ll',''))
select len(replace('hello hello','ll',''))
select replace(ename,'A','') from emp
select deptno,count(*) from emp group by deptno

select e.ename,e.sal,(select sum(d.sal) from emp d where d.empno<=e.empno) as running_total from emp e order by 3
select deptno,sum(sal)over() total,sum(sal)over(partition by deptno) d10 from emp

select distinct(d10/total)*100 as pct from(select deptno,sum(sal)over() total,sum(sal)over(partition by deptno) d10 from emp)x where deptno=10
select deptno,sum(sal) over(partition by deptno) total from emp


select sal,count(*) over() total from emp where deptno=20
select sum(sal) from emp group by deptno
select deptno,(case when deptno=10 then 'hello')x from emp
select sal,case when sal>1000 then 'high' else 'low' end as sal_exp from emp
select deptno,sum(sal) over(partition by deptno ) from emp

select avg(sal) from (select sal,count(*) over() total ,cast(count(*) over() as decimal)/2 mid,ceiling(cast(count(*) over() as decimal)/2) next,row_number()over(order by sal) rn from emp where deptno=20)x  where (total%2=0 and rn in (mid,mid+1)) or (total%2=1 and rn=next)

select distinct(d10/total)*100 as pct from(select deptno,sum(sal)over() total,sum(sal) over(partition by deptno) d10 from emp) x where deptno=10