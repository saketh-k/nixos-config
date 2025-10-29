#define VID_LOGITECH 0x046D
#define PID_SPACENAVIGATOR 0xC626

HID_BPF_CONFIG(
	HID_DEVICE(BUS_USB, HID_GROUP_ANY, VID_LOGITECH, PID_SPACENAVIGATOR)
);

/*
 * The 3Dconnexion SpaceNavigator 3D Mouse is a multi-axis controller with 6
 * axes (grouped as X,Y,Z and Rx,Ry,Rz).  Axis data is absolute, but the report
 * descriptor erroneously declares it to be relative.  We fix the report
 * descriptor to mark both axis collections as absolute.
 *
 * The kernel attempted to fix this in commit 24985cf68612 (HID: support
 * Logitech/3DConnexion SpaceTraveler and SpaceNavigator), but the descriptor
 * data offsets are incorrect for at least some SpaceNavigator units.
 */

SEC(HID_BPF_RDESC_FIXUP)
int BPF_PROG(hid_fix_rdesc, struct hid_bpf_ctx *hctx)
{
	__u8 *data = hid_bpf_get_data(hctx, 0 /* offset */, 4096 /* size */);

	if (!data) {
		return 0; /* EPERM check */
	}

	/* Offset of Input item in X,Y,Z and Rx,Ry,Rz collections. */
	const u8 offsets[] = {36, 53};

	for (int idx = 0; idx < ARRAY_SIZE(offsets); idx++) {
		u8 offset = offsets[idx];

		/* if Input (Data,Var,Rel) , make it Input (Data,Var,Abs) */
		if (data[offset] == 0x81 && data[offset + 1] == 0x06) {
			data[offset + 1] = 0x02;
		}
	}

	return 0;
}

HID_BPF_OPS(logitech_spacenavigator) = {
	.hid_rdesc_fixup = (void *)hid_fix_rdesc,
};

SEC("syscall")
int probe(struct hid_bpf_probe_args *ctx)
{
	/* Ensure report descriptor has expected size. */
	ctx->retval = ctx->rdesc_size != 228;
	if (ctx->retval) {
		ctx->retval = -EINVAL;
	}

	return 0;
}
