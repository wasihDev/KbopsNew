// Scaffold(
// backgroundColor: Colors.grey[200],
// appBar: AppBar(
// centerTitle: true,
// iconTheme: IconThemeData(
// color: Colors.white, //change your color here
// ),
// backgroundColor: Color.fromARGB(255, 196, 38, 64),
// title: Image.asset(
// 'images/kBOPS Top Logo.png',
// height: 100,
// width: 100,
// fit: BoxFit.fill,
// ),
// ),
// body: Padding(
// padding: const EdgeInsets.all(8.0),
// child: SingleChildScrollView(
// child: Column(
// children: [
// isLoading
// ? Container(
// margin: EdgeInsets.symmetric(vertical: 50),
// child: Center(
// child: CircularProgressIndicator(),
// ),
// )
// : Container(),
// Row(
// children: [
// SizedBox(
// width: 10,
// ),
// Image.asset(
// 'images/hand.png',
// height: 30,
// width: 30,
// fit: BoxFit.fill,
// ),
// SizedBox(
// width: 5,
// ),
// Text(
// 'Charged',
// style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
// ),
// ],
// ),
// SizedBox(
// height: 10,
// ),
// Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.all(Radius.circular(10))),
// height: MediaQuery.of(context).size.height * 0.3,
// width: MediaQuery.of(context).size.width * 1,
// child: ListView.builder(
// itemCount: kPointsChargedList.length,
// itemBuilder: (BuildContext context, int i) {
// KPointsUsedHistoryModel kPoints = kPointsChargedList[i];
// Timestamp? t = kPoints.KPointsDate;
// DateTime d = t!.toDate();
// return Card(
// elevation: 1,
// child: ListTile(
// title: Text(kPoints.KPointsOption.toString()),
// subtitle: Text(
// '${d.year}-${d.month}-${d.day}  ${d.hour}:${d.minute}'),
// ),
// );
// }),
// ),
// SizedBox(
// height: 10,
// ),
// Row(
// children: [
// SizedBox(
// width: 10,
// ),
// Image.asset(
// 'images/accept.png',
// height: 30,
// width: 30,
// fit: BoxFit.fill,
// ),
// SizedBox(
// width: 5,
// ),
// Text(
// 'Used',
// style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
// ),
// ],
// ),
// SizedBox(
// height: 10,
// ),
// Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.all(Radius.circular(10))),
// height: MediaQuery.of(context).size.height * 0.35,
// width: MediaQuery.of(context).size.width * 1,
// child: ListView.builder(
// itemCount: kPointsUsedList.length,
// itemBuilder: (BuildContext context, int i) {
// KPointsUsedHistoryModel kPoints = kPointsUsedList[i];
// Timestamp? t = kPoints.KPointsDate;
// DateTime d = t!.toDate();
// return Card(
// elevation: 1,
// child: ListTile(
// title: Text(kPoints.KPointsOption.toString()),
// subtitle: Text(
// '${d.year}-${d.month}-${d.day}  ${d.hour}:${d.minute}'),
// ),
// );
// }),
// )
// ],
// ),
// ),
// ),
// );
