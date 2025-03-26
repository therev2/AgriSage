import 'package:agrisage/ColorPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'GeminiChatController.dart';

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({super.key});

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  late GeminiChatController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GeminiChatController(updateState: setState);
  }

  void _handleClearChat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.delete_outline, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Clear Conversation'),
            ],
          ),
          content: const Text(
              'Are you sure you want to clear this conversation? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                _controller.clearChat();
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    return Scaffold(
      backgroundColor: ColorPage.offWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            if(isDesktop) _wid(),
            Padding(padding: const EdgeInsets.all(8)),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorPage.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                color: ColorPage.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Gemini Assistant",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _handleClearChat,
            color: Colors.black87,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status indicator with improved design
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: _controller.isLoading
                ? ColorPage.primaryColor
                : Colors.green,
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _controller.isLoading ? Colors.orange : Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _controller.isLoading
                      ? "Gemini is thinking..."
                      : "Gemini is ready",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _controller.isLoading
                        ? Colors.orange.shade800
                        : Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Chat(
              messages: _controller.messages,
              onSendPressed: _controller.sendMessage,
              user: _controller.user,
              showUserAvatars: true,
              showUserNames: true,
              inputOptions: const InputOptions(
                sendButtonVisibilityMode: SendButtonVisibilityMode.always,
              ),
              theme: DefaultChatTheme(
                primaryColor: ColorPage.primaryColor,
                secondaryColor: ColorPage.offWhite,
                backgroundColor: Colors.white,
                inputBackgroundColor: ColorPage.offWhite,
                inputTextColor: Colors.black87,
                inputTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                sentMessageBodyTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                receivedMessageBodyTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
                userAvatarNameColors: [ColorPage.primaryColor],
                inputBorderRadius: BorderRadius.circular(20),
                messageBorderRadius: 16,
                sendButtonIcon: Icon(
                  Icons.send_rounded,
                  color: ColorPage.primaryColor,
                ),
              ),
              emptyState: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ColorPage.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: ColorPage.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Start a conversation with Gemini",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Ask questions about agriculture, farming, or get recommendations",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Wrap(
                      //   spacing: 12,
                      //   runSpacing: 12,
                      //   alignment: WrapAlignment.center,
                      //   children: [
                      //     _suggestionChip("Tell me about sustainable agriculture"),
                      //     _suggestionChip("How to improve crop yield?"),
                      //     _suggestionChip("Latest farming techniques"),
                      //     _suggestionChip("Organic pest control methods"),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_controller.isLoading)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LinearProgressIndicator(
                backgroundColor: ColorPage.offWhite,
                valueColor: AlwaysStoppedAnimation<Color>(
                    ColorPage.primaryColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _wid(){
    return IconButton(onPressed: () { Navigator.pop(context); },
      icon: Icon(Icons.arrow_back),

    );
  }
//   Widget _suggestionChip(String text) {
//     return InkWell(
//       onTap: () {
//         _controller.sendMessage(types.PartialText(text: text));
//       },
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: ColorPage.primaryColor,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: ColorPage.primaryColor,
//             width: 1,
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: ColorPage.primaryColor,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
}