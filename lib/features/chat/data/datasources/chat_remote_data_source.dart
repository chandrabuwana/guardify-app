import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';
import '../models/chat_api_response_model.dart';
import '../../../../features/bmi/data/models/bmi_api_response_model.dart';

part 'chat_remote_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class ChatRemoteDataSource {
  @factoryMethod
  factory ChatRemoteDataSource(Dio dio) = _ChatRemoteDataSource;

  /// Create a new conversation
  /// POST /Chat/conversations/create
  @POST('/Chat/conversations/create')
  Future<CreateConversationResponseModel> createConversation(
    @Body() CreateConversationRequestModel request,
  );

  /// Get list of users for chat
  /// POST /User/list
  @POST('/User/list')
  Future<UserListResponseModel> getUserList(
    @Body() UserListRequestModel request,
  );

  /// Send a message
  /// POST /Chat/message/send
  @POST('/Chat/message/send')
  Future<SendMessageResponseModel> sendMessage(
    @Body() SendMessageRequestModel request,
  );

  /// Get list of messages
  /// POST /Chat/message/list
  @POST('/Chat/message/list')
  Future<ListMessageResponseModel> getMessages(
    @Body() ListMessageRequestModel request,
  );

  /// Get list of conversations
  /// POST /Chat/conversations/list
  @POST('/Chat/conversations/list')
  Future<ListConversationResponseModel> getConversations(
    @Body() ListConversationRequestModel request,
  );
}
