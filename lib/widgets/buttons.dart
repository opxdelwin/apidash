import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import "snackbars.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({
    super.key,
    required this.toCopy,
    this.showLabel = true,
  });

  final String toCopy;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: showLabel ? '' : l10n!.kLabelCopy,
      child: SizedBox(
        width: showLabel ? null : kTextButtonMinWidth,
        child: TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: toCopy));
            sm.hideCurrentSnackBar();
            sm.showSnackBar(getSnackBar("Copied"));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.content_copy,
                size: 20,
              ),
              if (showLabel) Text(l10n!.kLabelCopy)
            ],
          ),
        ),
      ),
    );
  }
}

class SendRequestButton extends StatelessWidget {
  const SendRequestButton({
    super.key,
    required this.selectedId,
    required this.sentRequestId,
    required this.onTap,
  });

  final String? selectedId;
  final String? sentRequestId;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    bool disable = sentRequestId != null;
    return FilledButton(
      onPressed: disable ? null : onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            disable
                ? (selectedId == sentRequestId
                    ? l10n!.kLabelSending
                    : l10n!.kLabelBusy)
                : l10n!.kLabelSend,
            style: kTextStyleButton,
          ),
          if (!disable) kHSpacer10,
          if (!disable)
            const Icon(
              size: 16,
              Icons.send,
            ),
        ],
      ),
    );
  }
}

class SaveInDownloadsButton extends StatelessWidget {
  const SaveInDownloadsButton({
    super.key,
    this.content,
    this.mimeType,
    this.ext,
    this.name,
    this.showLabel = true,
  });

  final Uint8List? content;
  final String? mimeType;
  final String? ext;
  final String? name;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: showLabel ? '' : l10n!.kLabelDownload,
      child: SizedBox(
        width: showLabel ? null : kTextButtonMinWidth,
        child: TextButton(
          onPressed: (content != null)
              ? () async {
                  var message = "";
                  var path = await getFileDownloadpath(
                    name,
                    ext ?? getFileExtension(mimeType),
                  );
                  if (path != null) {
                    try {
                      await saveFile(path, content!);
                      var sp = getShortPath(path);
                      message = 'Saved to $sp';
                    } catch (e) {
                      message = "An error occurred while saving file.";
                    }
                  } else {
                    message = "Unable to determine the download path.";
                  }
                  sm.hideCurrentSnackBar();
                  sm.showSnackBar(getSnackBar(message, small: false));
                }
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.download,
                size: 20,
              ),
              if (showLabel) Text(l10n!.kLabelDownload)
            ],
          ),
        ),
      ),
    );
  }
}

class RepoButton extends StatelessWidget {
  const RepoButton({
    super.key,
    this.text,
    this.icon,
  });

  final String? text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    var label = text ?? "GitHub";
    if (icon == null) {
      return FilledButton(
        onPressed: () {
          launchUrl(Uri.parse(kGitUrl));
        },
        child: Text(
          label,
          style: kTextStyleButton,
        ),
      );
    }
    return FilledButton.icon(
      onPressed: () {
        launchUrl(Uri.parse(kGitUrl));
      },
      icon: Icon(
        icon,
        size: 20.0,
      ),
      label: Text(
        label,
        style: kTextStyleButton,
      ),
    );
  }
}

class DiscordButton extends StatelessWidget {
  const DiscordButton({
    super.key,
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    var label = text ?? 'Discord Server';
    return FilledButton.icon(
      onPressed: () {
        launchUrl(Uri.parse(kDiscordUrl));
      },
      icon: const Icon(
        Icons.discord,
        size: 20.0,
      ),
      label: Text(
        label,
        style: kTextStyleButton,
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.save,
        size: 20,
      ),
      label: Text(
        l10n!.kLabelSave,
        style: kTextStyleButton,
      ),
    );
  }
}
