create policy "products read all"
on products for select
to authenticated
using (true);

create policy "products write admin_manager"
on products for all
to authenticated
using ((auth.jwt() ->> 'role') in ('admin','manager'));
