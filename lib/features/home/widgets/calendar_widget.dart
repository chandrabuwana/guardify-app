import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  final String monthName;
  final List<List<String>> weekData;
  final List<int> redDates;

  const CalendarWidget({
    super.key,
    required this.monthName,
    required this.weekData,
    this.redDates = const [],
  });

  @override
  Widget build(BuildContext context) {
    const weekDays = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jadwal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  monthName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Week day headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekDays
                      .map((day) => SizedBox(
                            width: 35,
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                // Calendar dates
                ...weekData.map((week) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: week.map((date) {
                          final isRed = date.isNotEmpty &&
                              redDates.contains(int.tryParse(date));
                          return SizedBox(
                            width: 35,
                            height: 35,
                            child: date.isEmpty
                                ? const SizedBox()
                                : Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      date,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isRed
                                            ? const Color(0xFFE74C3C)
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                          );
                        }).toList(),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
