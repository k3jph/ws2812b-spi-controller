Import("env")

upload_protocol = env.subst("$UPLOAD_PROTOCOL")

def before_fuses(source, target, env):
    print("before_fuses")
    fuses_section = "fuses"

    board = env.BoardConfig()
    lfuse = board.get("%s.lfuse" % fuses_section, "")
    hfuse = board.get("%s.hfuse" % fuses_section, "")
    efuse = board.get("%s.efuse" % fuses_section, "")
    lock = board.get("%s.lock_bits" % fuses_section, "0xff")

    # write out the fuse data to a file minipro knows
    fuses_file_name = env.get("BUILD_DIR") + "/" + env.get("PROGNAME") + ".fuses.conf"
    env.Execute(f"echo fuses_lo = {lfuse} > {fuses_file_name}")
    env.Execute(f"echo fuses_hi = {hfuse} >> {fuses_file_name}")
    env.Execute(f"echo fuses_ext = {efuse} >> {fuses_file_name}")
    env.Execute(f"echo lock_byte = {lock} >> {fuses_file_name}")

if upload_protocol == "minipro":
    env.AddPreAction("fuses", before_fuses)

    env.Replace(
        FUSESUPLOADER="minipro",
        FUSESUPLOADERFLAGS = [
            "-p",
            "$BOARD_MCU",
            "-c",
            "config",
            "-w",
            "${BUILD_DIR}/${PROGNAME}.fuses.conf"
        ],
        SETFUSESCMD = "$FUSESUPLOADER $FUSESUPLOADERFLAGS",
    )

    env.Replace(
        UPLOADER="minipro",
        MINIPROFLAGS=[
            "-p", 
            "$BOARD",
            "-f",
            "ihex"
        ],
        UPLOADCMD="$UPLOADER $MINIPROFLAGS -w $SOURCES",
    )
    upload_actions = [env.VerboseAction("$UPLOADCMD", "Uploading $SOURCE")]
