surface_free(shellSurface);
if (ds_exists(deferredQueue, ds_type_queue)) {
	ds_queue_destroy(deferredQueue);
}
ds_map_destroy(WC_builtins);
