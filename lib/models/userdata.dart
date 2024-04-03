import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Userinfo {
  String? UserID;
  String? Username;
  String? UserImage;
  int? TotalKPoints;
  String? MyReferralCode;
  String? SocialMedia;
  String? Email;
  String? RewardDate;
  bool? ReferralUsed;
  String? AdsDate;
  int? Ads;
  int? Ads2;

  Userinfo(
      {required this.UserID,
      required this.Username,
      required this.UserImage,
      required this.TotalKPoints,
      required this.MyReferralCode,
      required this.SocialMedia,
      required this.Email,
      required this.RewardDate,
      required this.ReferralUsed,
      required this.Ads,
      required this.Ads2,
      required this.AdsDate});

  factory Userinfo.fromMap(map) {
    Map<String, dynamic>? dataMap =
        map.data(); // Convert to Map<String, dynamic>

    return Userinfo(
        UserID: map['userid'],
        Username: map['username'],
        UserImage: map['userimage'],
        TotalKPoints: map['totalkpoints'],
        MyReferralCode: map['myreferralcode'],
        SocialMedia: map['socialmedia'],
        Email: map['email'],
        RewardDate: map['rewardDate'],
        ReferralUsed: map['referralUsed'],
        Ads: map['ads'],
        Ads2: dataMap != null && dataMap.containsKey('ads2')
            ? dataMap['ads2']
            : 0,
        AdsDate: map['adsDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userid'] = this.UserID;
    data['username'] = this.Username;
    data['userimage'] = this.UserImage;
    data['totalkpoints'] = this.TotalKPoints;
    data['myreferralcode'] = this.MyReferralCode;
    data['socialmedia'] = this.SocialMedia;
    data['email'] = this.Email;

    return data;
  }
}

class Comments {
  String? CommentID;
  String? UsernameID;
  String? CommentDescription;
  Timestamp? CommentDate;
  String? EventId;
  String? userName;
  Comments(
      {required this.CommentID,
      required this.UsernameID,
      required this.CommentDescription,
      required this.CommentDate,
      required this.EventId,
      this.userName});

  factory Comments.fromMap(map) {
    return Comments(
        CommentID: map['commentId'],
        UsernameID: map['userId'],
        CommentDescription: map['commentDescription'],
        CommentDate: map['commentDate'],
        EventId: map['eventId'],
        userName: map['userName']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['commentsid'] = this.CommentID;
    data['usernameid'] = this.UsernameID;
    data['commentdescription'] = this.CommentDescription;
    data['commentdate'] = this.CommentDate;
    data['userName'] = this.userName;

    return data;
  }
}

class CommunityComment {
  final String id;
  final String text;
  final String userId;
  String? userName;
  final String profileImage;
  final DateTime time;
  final int likes;
  final List<String> likedBy;

  CommunityComment(
      {required this.id,
      required this.text,
      required this.userId,
      required this.userName,
      required this.profileImage,
      required this.time,
      this.likes = 0,
      required this.likedBy});

  factory CommunityComment.fromJson(Map<String, dynamic> map, String id) {
    return CommunityComment(
        id: id,
        text: map['text'],
        userId: map['userId'],
        userName: map['userName'] ?? "",
        profileImage: map['profileImage'],
        time: DateTime.parse(map['time']),
        likes: map['likes'],
        likedBy: List<String>.empty(growable: true));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'userId': userId,
      'userName': userName ?? "",
      'profileImage': profileImage,
      'time': time.toIso8601String(),
      'likes': likes,
      'likedBy': likedBy
    };
  }
}

class WeeklyCharts {
  int? totalVotes;
  Timestamp? startDate;
  Timestamp? endDate;
  String? urlWebView;

  WeeklyCharts(
      {required this.totalVotes,
      required this.startDate,
      required this.endDate,
      required this.urlWebView});

  factory WeeklyCharts.fromMap(map) {
    return WeeklyCharts(
        totalVotes: map['totalVotes'],
        startDate: map['startDate'],
        endDate: map['endDate'],
        urlWebView: map['urlWebView']);
  }
}

class WeeklyParticipants {
  String? image;
  String? imageBanner;
  String? name;
  int? totalVotes;
  String? participantId;

  WeeklyParticipants(
      {required this.image,
      required this.imageBanner,
      required this.name,
      required this.totalVotes,
      required this.participantId});

  factory WeeklyParticipants.fromMap(map) {
    return WeeklyParticipants(
        image: map['image'],
        imageBanner: map['imageBanner'],
        name: map['name'],
        totalVotes: map['totalVotes'],
        participantId: map['participantId']);
  }
}

class EventsInfo {
  String? EventID;
  String? EventName;
  String? EventDescription;
  String? EventImage;
  String? EventStatus;
  Timestamp? EventStartDate;
  Timestamp? EventEndDate;
  int? EventTotalVotes;

  EventsInfo(
      {required this.EventID,
      required this.EventName,
      required this.EventDescription,
      required this.EventImage,
      required this.EventStatus,
      required this.EventStartDate,
      required this.EventEndDate,
      required this.EventTotalVotes});

  factory EventsInfo.fromMap(map) {
    Timestamp t = map['eventStartDate'];
    DateTime d = t.toDate();
    Timestamp t2 = map['eventEndDate'];
    DateTime d2 = t2.toDate();
    return EventsInfo(
        EventID: map['eventId'],
        EventName: map['eventName'],
        EventDescription: map['eventDescription'],
        EventImage: map['eventImage'],
        EventStatus: map['eventStatus'],
        // EventStartDate: "${d.year}-${d.month}-${d.day}",
        EventStartDate: map['eventStartDate'],
        // EventEndDate: "${d2.year}-${d2.month}-${d2.day}",
        EventEndDate: map['eventEndDate'],
        EventTotalVotes: map['eventTotalVotes']);
  }
}

class EventsParticipant {
  String? EventId;
  String? ParticipantID;
  String? ParticipantName;
  String? ParticipantImage;
  int? ParticipantTotalVotes;
  int? ParticipantPercentage;

  EventsParticipant(
      {required this.EventId,
      required this.ParticipantID,
      required this.ParticipantName,
      required this.ParticipantImage,
      required this.ParticipantTotalVotes,
      required this.ParticipantPercentage});

  factory EventsParticipant.fromMap(map) {
    return EventsParticipant(
        EventId: map['eventId'],
        ParticipantID: map['participantId'],
        ParticipantName: map['participantName'],
        ParticipantImage: map['participantImage'],
        ParticipantTotalVotes: map['participantTotalVotes'],
        ParticipantPercentage: map['participantPercentage']);
  }
}

class EventVotes {
  String? EventVotesID;
  int? KPointsVoted;
  String? UserID;
  String? ParticipantID;
  String? ParticipantName;
  String? Eventname;

  EventVotes(
      {required this.EventVotesID,
      required this.KPointsVoted,
      required this.UserID,
      required this.ParticipantID,
      required this.ParticipantName,
      required this.Eventname});

  factory EventVotes.fromMap(Map<dynamic, dynamic> map) {
    return EventVotes(
        EventVotesID: map['eventvotesid'],
        KPointsVoted: map['kpointsvoted'],
        UserID: map['userid'],
        ParticipantID: map['participantid'],
        ParticipantName: map['participantname'],
        Eventname: map['eventname']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['eventvotesid'] = this.EventVotesID;
    data['kpointsvoted'] = this.KPointsVoted;
    data['userid'] = this.UserID;
    data['participantid'] = this.ParticipantID;
    data['participantname'] = this.ParticipantName;
    data['eventname'] = this.Eventname;

    return data;
  }
}

// class Comments {
//   String? CommentID;
//   String? UsernameID;
//   String? CommentDescription;
//   Timestamp? CommentDate;
//   String? EventId;
//   Comments(
//       {required this.CommentID,
//       required this.UsernameID,
//       required this.CommentDescription,
//       required this.CommentDate,
//       required this.EventId});

//   factory Comments.fromMap(map) {
//     return Comments(
//         CommentID: map['commentId'],
//         UsernameID: map['userId'],
//         CommentDescription: map['commentDescription'],
//         CommentDate: map['commentDate'],
//         EventId: map['eventId']);
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['commentsid'] = this.CommentID;
//     data['usernameid'] = this.UsernameID;
//     data['commentdescription'] = this.CommentDescription;
//     data['commentdate'] = this.CommentDate;

//     return data;
//   }
// }

class FirebaseImageModel {
  String imageUrl;
  String userName;
  DateTime imageUploadTime;
  String docId;
  String userProfileImage;
  String uploadUserId;
  int? likecount;
  int? dislikecount;
  List<String> likedBy;

  FirebaseImageModel(
      {required this.imageUrl,
      required this.userName,
      required this.imageUploadTime,
      required this.docId,
      required this.userProfileImage,
      required this.uploadUserId,
      this.likecount,
      this.dislikecount,
      required this.likedBy});

  factory FirebaseImageModel.fromJson(Map<String, dynamic> json) {
    return FirebaseImageModel(
        imageUrl: json['imageUrl'],
        userName: json['userName'],
        imageUploadTime: (json['uploadTime'] as Timestamp).toDate(),
        docId: json['docId'],
        userProfileImage: json['userProfileImage'],
        uploadUserId: json['uploadUserId'],
        likecount: json['likecount'],
        dislikecount: json['dislikecount'],
        likedBy: List<String>.from(json['likedBy']));
  }

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'userName': userName,
        'uploadTime': imageUploadTime,
        'docId': docId,
        'userProfileImage': userProfileImage,
        'uploadUserId': uploadUserId,
        'likecount': likecount,
        'dislikecount': dislikecount,
        'likedBy': likedBy
      };
}

class Reports {
  String? ReportID;
  String? CommentID;
  String? ReportedID;
  String? WhoReportedID;
  String? ReportedDate;
  String? ReportDescription;
  Bool? ReportAgree;

  Reports(
      {required this.ReportID,
      required this.CommentID,
      required this.ReportedID,
      required this.WhoReportedID,
      required this.ReportedDate,
      required this.ReportDescription,
      required this.ReportAgree});

  factory Reports.fromMap(Map<dynamic, dynamic> map) {
    return Reports(
        ReportID: map['reportid'],
        CommentID: map['commentid'],
        ReportedID: map['reportedid'],
        WhoReportedID: map['whoreportedid'],
        ReportedDate: map['reporteddate'],
        ReportDescription: map['reportdescription'],
        ReportAgree: map['reportagree']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['reportid'] = this.ReportID;
    data['commentid'] = this.CommentID;
    data['reportedid'] = this.ReportedID;
    data['whoreportedid'] = this.WhoReportedID;
    data['reporteddate'] = this.ReportedDate;
    data['reportdescription'] = this.ReportDescription;
    data['reportagree'] = this.ReportAgree;

    return data;
  }
}

class KPointsUsedHistoryModel {
  String? KPointsID;
  String? UsernameID;
  Timestamp? KPointsDate;
  String? KPointsMethod;

  int? KPointsValue;

  String? KPointsOption;

  KPointsUsedHistoryModel(
      {required this.KPointsID,
      required this.UsernameID,
      required this.KPointsDate,
      required this.KPointsMethod,
      required this.KPointsValue,
      required this.KPointsOption});

  factory KPointsUsedHistoryModel.fromMap(map) {
    return KPointsUsedHistoryModel(
        KPointsID: map['kPointsId'],
        UsernameID: map['userId'],
        KPointsDate: map['kPointsDate'],
        KPointsMethod: map['kPointsMethod'],
        KPointsValue: map['kPointsValue'],
        KPointsOption: map['kPointsOption']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['kpointsid'] = this.KPointsID;
    data['usernameid'] = this.UsernameID;
    data['kpointsdate'] = this.KPointsDate;
    data['kpointsmethod'] = this.KPointsMethod;
    data['kpointsvalue'] = this.KPointsValue;
    data['kpointsoption'] = this.KPointsOption;

    return data;
  }
}

class Store {
  String? SoreNotice;

  Store({required this.SoreNotice});

  factory Store.fromMap(Map<dynamic, dynamic> map) {
    return Store(SoreNotice: map['storenotice']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['storenotice'] = this.SoreNotice;

    return data;
  }
}

class ExchangeKPoints {
  String? RedeemID;

  String? RedeemItemName;

  int? RedeemItemKPoints;

  ExchangeKPoints(
      {required this.RedeemID,
      required this.RedeemItemName,
      required this.RedeemItemKPoints});

  factory ExchangeKPoints.fromMap(map) {
    return ExchangeKPoints(
        RedeemID: map['redeemId'],
        RedeemItemName: map['redeemItemName'],
        RedeemItemKPoints: map['redeemItemKPoints']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['redeemid'] = this.RedeemID;
    data['redeemitemname'] = this.RedeemItemName;
    data['redeemitemkpoints'] = this.RedeemItemKPoints;

    return data;
  }
}

class RedeemHistory {
  String? RedeemHistoryID;

  String? RedeemDate;

  String? RedeemID;

  String? UsernameID;

  String? RedeemItemName;

  int? RedeemItemKPoints;

  RedeemHistory(
      {required this.RedeemHistoryID,
      required this.RedeemDate,
      required this.RedeemID,
      required this.UsernameID,
      required this.RedeemItemName,
      required this.RedeemItemKPoints});

  factory RedeemHistory.fromMap(Map<dynamic, dynamic> map) {
    return RedeemHistory(
        RedeemHistoryID: map['reddemhistoryid'],
        RedeemDate: map['reddemdate'],
        RedeemID: map['redeemid'],
        UsernameID: map['usernameid'],
        RedeemItemName: map['redeemitemname'],
        RedeemItemKPoints: map['redeemitemkpoints']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['reddemhistoryid'] = this.RedeemHistoryID;
    data['reddemdate'] = this.RedeemDate;
    data['redeemid'] = this.RedeemID;
    data['usernameid'] = this.UsernameID;
    data['redeemitemname'] = this.RedeemItemName;
    data['redeemitemkpoints'] = this.RedeemItemKPoints;
    return data;
  }
}

class BannerImage {
  String? ImageSlider;
  String? ImageSliderLink;

  BannerImage({
    required this.ImageSlider,
    required this.ImageSliderLink,
  });

  factory BannerImage.fromMap(Map<dynamic, dynamic> map) {
    return BannerImage(
      ImageSlider: map['imageSlider'],
      ImageSliderLink: map['imageSliderLink'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['imageSlider'] = this.ImageSlider;
    data['imageSliderLink'] = this.ImageSliderLink;

    return data;
  }
}
