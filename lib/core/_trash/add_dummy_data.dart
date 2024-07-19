







// GestureDetector(
//               onTap: () async {
//                 final isarInstance = serviceLocator<Isar>();

//                 final dateList = List.generate(267,
//                     (index) => DateTime.now().subtract(Duration(days: index)));

//                 final reviews = [
//                   "Today's fast left me feeling cleansed and peaceful. The sense of clarity I gained was refreshing, making the experience truly worthwhile.",
//                   "It was a challenging fast, but I feel accomplished. Pushing through the hunger and fatigue has strengthened my resolve and discipline.",
//                   "I felt spiritually and physically rejuvenated after the fast. The entire day felt like a reset, giving me a renewed sense of energy and focus.",
//                   "The fast was tough today, and I felt quite drained. Despite the difficulty, I learned a lot about my limits and resilience.",
//                   "It was a smooth and fulfilling fast, both mentally and physically. The sense of calm and satisfaction I experienced was profound.",
//                   "Today’s fast was difficult, but ultimately rewarding. The struggle made the eventual relief and sense of achievement all the more meaningful.",
//                   "I felt a strong sense of clarity and focus during the fast. The absence of food sharpened my mind and heightened my awareness throughout the day.",
//                   "The fast was harder than expected, and I struggled with hunger. Nevertheless, it was a humbling experience that taught me patience and perseverance.",
//                   "It was a calm and reflective fast, which I really appreciated. The quiet time allowed me to connect with my thoughts and emotions on a deeper level.",
//                   "Today’s fast was uncomfortable and left me feeling weak. However, the discomfort was a reminder of the importance of gratitude and resilience.",
//                   "This fast was a mental challenge, but it provided a great sense of inner peace. The tranquility I felt was worth the effort.",
//                   "Despite the physical discomfort, the fast helped me achieve a deeper spiritual connection. It was a day of profound reflection and growth.",
//                   "The fast was surprisingly easy today. I felt in tune with my body and mind, making the experience enjoyable and enlightening.",
//                   "I struggled with cravings during the fast, but overcoming them gave me a sense of empowerment and control.",
//                   "The fast today brought a new level of self-awareness. The insights gained were invaluable, making the hunger and fatigue seem insignificant.",
//                   "It was a long and tiring fast, but the sense of accomplishment at the end was incredibly rewarding.",
//                   "Today’s fast felt like a journey of self-discovery. Each moment of hunger brought a deeper understanding of my resilience and strength.",
//                   "The fast was more challenging than usual, but it provided an opportunity to practice patience and mindfulness.",
//                   "I found a surprising amount of energy during today’s fast. The experience was invigorating and left me feeling revitalized.",
//                   "Although the fast was tough, the clarity and peace I experienced made it all worthwhile. It was a reminder of the benefits of perseverance and discipline.",
//                 ];
//                 int i = 0;

//                 for (var date in dateList) {
//                   final noOfFasts = Random().nextInt(2);
//                   for (int i = 0; i < noOfFasts; i++) {
//                     await isarInstance.writeTxn(() async {
//                       final duration =
//                           Duration(hours: Random().nextInt(11) + 13);
//                       final startTime = date
//                           .subtract(Duration(hours: Random().nextInt(10) + 1));
//                       final endTime = startTime.add(duration);
//                       await isarInstance.fastModels.put(
//                         FastModel(
//                           durationInMilliseconds: duration.inMilliseconds,
//                           completedDurationInMilliseconds:
//                               duration.inMilliseconds,
//                           startTime: startTime,
//                           endTime: endTime,
//                           isarId: null,
//                           note: reviews[Random().nextInt(10)],
//                           rating: Random().nextInt(5),
//                           savedOn: DateTime(date.year, date.month, date.day),
//                           status: FastStatus.finished,
//                           fastingTimeRatio: FastingTimeRatioEntity(
//                             eat: 24 - duration.inHours,
//                             fast: duration.inHours,
//                           ),
//                         ),
//                       );
//                     });
//                   }
//                   i++;
//                   print('$i / 200 done');
//                 }
//                 print('DONE DONE DONE');
//               },
//               child: Container(
//                 height: 5.r,
//                 width: 5.r,
//                 decoration: const BoxDecoration(
//                   color: ColorConstantsDark.container2Color,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             )
































































