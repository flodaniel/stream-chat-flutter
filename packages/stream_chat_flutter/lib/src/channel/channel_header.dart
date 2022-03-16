import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/src/channel/channel_info.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template channelHeader}
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/channel_header.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/channel_header_paint.png)
///
/// Shows information about the current [Channel].
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   final StreamChatClient client;
///   final Channel channel;
///
///   MyApp(this.client, this.channel);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: StreamChat(
///         client: client,
///         child: StreamChannel(
///           channel: channel,
///           child: Scaffold(
///             appBar: ChannelHeader(),
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// Usually you would use this widget as an [AppBar] inside a [Scaffold].
/// However, you can also use it as a normal widget.
///
/// Make sure to have a [StreamChannel] ancestor in order to provide the
/// information about the channel.
///
/// Every part of the widget uses a [StreamBuilder] to render the channel
/// information as soon as it updates.
///
/// By default the widget shows a backButton that calls [Navigator.pop].
/// You can disable this button using the [showBackButton] property.
/// Alternatively, you can override this behaviour via the [onBackPressed]
/// callback.
///
/// The UI is rendered based on the first ancestor of type [StreamChatTheme]
/// and the [ChannelTheme.channelHeaderTheme] property. Modify it to change
/// the widget's appearance.
/// {@endtemplate}
class ChannelHeader extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro channelHeader}
  const ChannelHeader({
    Key? key,
    this.showBackButton = true,
    this.onBackPressed,
    this.onTitleTap,
    this.showTypingIndicator = true,
    this.onImageTap,
    this.showConnectionStateTile = false,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.backgroundColor,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  /// Whether to show the leading back button
  ///
  /// Defaults to `true`
  final bool showBackButton;

  /// The action to perform when the back button is pressed.
  ///
  /// By default it calls [Navigator.pop]
  final VoidCallback? onBackPressed;

  /// The action to perform when the header is tapped.
  final VoidCallback? onTitleTap;

  /// The action to perform when the image is tapped.
  final VoidCallback? onImageTap;

  /// Whether to show the typing indicator
  ///
  /// Defaults to `true`
  final bool showTypingIndicator;

  /// Whether to show the connection state tile
  final bool showConnectionStateTile;

  /// Title widget
  final Widget? title;

  /// Subtitle widget
  final Widget? subtitle;

  /// Leading widget
  final Widget? leading;

  /// {@macro flutter.material.appbar.actions}
  ///
  /// The [ChannelAvatar] is shown by default
  final List<Widget>? actions;

  /// The background color for this [ChannelHeader].
  final Color? backgroundColor;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    final channelHeaderTheme = ChannelHeaderTheme.of(context);

    final leadingWidget = leading ??
        (showBackButton
            ? StreamBackButton(
                onPressed: onBackPressed,
                showUnreadCount: true,
              )
            : const SizedBox());

    return ConnectionStatusBuilder(
      statusBuilder: (context, status) {
        var statusString = '';
        var showStatus = true;

        switch (status) {
          case ConnectionStatus.connected:
            statusString = context.translations.connectedLabel;
            showStatus = false;
            break;
          case ConnectionStatus.connecting:
            statusString = context.translations.reconnectingLabel;
            break;
          case ConnectionStatus.disconnected:
            statusString = context.translations.disconnectedLabel;
            break;
        }

        final theme = Theme.of(context);

        return InfoTile(
          showMessage: showConnectionStateTile && showStatus,
          message: statusString,
          child: AppBar(
            toolbarTextStyle: theme.textTheme.bodyText2,
            titleTextStyle: theme.textTheme.headline6,
            systemOverlayStyle: theme.brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            elevation: 1, //TODO(Groovin): no elevation on desktop & web
            leading: leadingWidget,
            backgroundColor: backgroundColor ?? channelHeaderTheme.color,
            actions: actions ??
                <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Center(
                      child: ChannelAvatar(
                        borderRadius:
                            channelHeaderTheme.avatarTheme?.borderRadius,
                        constraints:
                            channelHeaderTheme.avatarTheme?.constraints,
                        onTap: onImageTap,
                      ),
                    ),
                  ),
                ],
            centerTitle: true,
            title: InkWell(
              onTap: onTitleTap,
              child: SizedBox(
                height: preferredSize.height,
                width: preferredSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    title ??
                        ChannelName(
                          textStyle: channelHeaderTheme.titleStyle,
                        ),
                    const SizedBox(height: 2),
                    subtitle ??
                        ChannelInfo(
                          showTypingIndicator: showTypingIndicator,
                          channel: channel,
                          textStyle: channelHeaderTheme.subtitleStyle,
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
