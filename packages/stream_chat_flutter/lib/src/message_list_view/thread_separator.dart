import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template threadSeparator}
/// A widget that separates messages in a thread. Not intended for use outside
/// of [StreamMessageWidget].
/// {@endtemplate}
class ThreadSeparator extends StatelessWidget {
  ///{@macro threadSeparator}
  const ThreadSeparator({
    Key? key,
    this.threadSeparatorBuilder,
    this.parentMessage,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final WidgetBuilder? threadSeparatorBuilder;

  // ignore: public_member_api_docs
  final Message? parentMessage;

  @override
  Widget build(BuildContext context) {
    if (threadSeparatorBuilder != null) {
      return threadSeparatorBuilder!.call(context);
    }

    final replyCount = parentMessage!.replyCount!;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: StreamChatTheme.of(context).colorTheme.bgGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          context.translations.threadSeparatorText(replyCount),
          textAlign: TextAlign.center,
          style: StreamChannelHeaderTheme.of(context).subtitleStyle,
        ),
      ),
    );
  }
}