import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/components/constants.dart';

Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor = Colors.blue,
  double radius = 4,
  bool isUpperCase = true,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );

Widget defaultTextButton({
  required VoidCallback onPressed,
  required String text,
}) =>
    TextButton(onPressed: onPressed, child: Text(text.toUpperCase()));

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator<String>? validate,
  required String label,
  required IconData? prefix,
  VoidCallback? onTap,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isPassword = false,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
}) =>
    TextFormField(
      obscureText: isPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      validator: validate,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      keyboardType: type,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map task, BuildContext context) => Dismissible(
      key: Key('${task['id']}'),
      onDismissed: (direction) {
        // AppCubit.get(context).deleteDataFromDatabase(id: task['id']);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              child: Text(
                task['time'],
                style: TextStyle(fontSize: 14.5),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    task['date'],
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            IconButton(
              onPressed: () {
                // AppCubit.get(context)
                //     .updateDataInDatabase(id: task['id'], status: 'done');
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            IconButton(
              onPressed: () {
                // AppCubit.get(context)
                //     .updateDataInDatabase(id: task['id'], status: 'archived');
              },
              icon: Icon(
                Icons.archive,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
Widget buildTasks({required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => buildDivider(),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet , Please Add Some Tasks ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
Widget buildLoadingIndicator() => const Center(
      child: CircularProgressIndicator(),
    );

Widget buildCenterText(
        {String text = 'Hello',
        double size = 17,
        Color color = Colors.black45,
        FontWeight fontWeight = FontWeight.w600}) =>
    Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );

Widget buildDivider() => Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Container(
        width: double.infinity,
        height: 1.5,
        color: Colors.grey[200],
      ),
    );

Future showToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

Color chooseToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.WARNING:
      return Colors.amber;
    case ToastStates.ERROR:
      return Colors.red;
    case ToastStates.SUCCESS:
      return Colors.green;
  }
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Widget buildArticleItem(
        {required Map article, required BuildContext context}) =>
    InkWell(
      onTap: () {
        // navigatoTo(
        //     context: context, widget: WebViewScreen(url: article['url']));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    '${article['urlToImage'] ?? urlToNoImageAvailable}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: SizedBox(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${article['title']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

Widget buildArticlesList({
  required List articles,
  required BuildContext context,
  bool isSearch = true,
}) =>
    ConditionalBuilder(
      condition: articles.isNotEmpty,
      builder: (context) => ListView.separated(
        cacheExtent: 99999,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) =>
            buildArticleItem(article: articles[index], context: context),
        separatorBuilder: (context, index) => buildDivider(),
        itemCount: articles.length,
      ),
      fallback: (context) => isSearch
          ? buildLoadingIndicator()
          : buildCenterText(text: "No Result Found"),
    );

void navigatoTo({required BuildContext context, required Widget widget}) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));

void navigatoAndFinish(
        {required BuildContext context, required Widget widget}) =>
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => widget),
      (route) => false,
    );

///snackBar
void showSnackbar(context, String text) {
  var snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(10),
    content: Text(text),
  );
  ScaffoldMessenger.of(context).showSnackBar(
    snackBar,
  );
}

Widget buildNetworkImage(
  url, {
  double height = 40,
  double width = 40,
  BoxFit fit = BoxFit.none,
}) =>
    CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) => buildLoadingIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
