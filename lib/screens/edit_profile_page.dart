import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/generated/app_localizations.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.api,
    required this.token,
  });

  final ChengeApi api;
  final String token;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nickname = TextEditingController();
  final _bio = TextEditingController();
  final _website = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _birthday = TextEditingController();
  final _picker = ImagePicker();

  String? _avatarUrl;
  int? _gender;
  bool _loading = true;
  bool _saving = false;
  bool _uploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nickname.dispose();
    _bio.dispose();
    _website.dispose();
    _phone.dispose();
    _email.dispose();
    _birthday.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.api.currentUser(widget.token);
      if (!mounted) return;
      final profiles = data['profiles'];
      final user = data['user'];
      Map<String, dynamic>? profileMap;
      if (profiles is Map<String, dynamic>) {
        profileMap = profiles;
      } else if (profiles is Map) {
        profileMap = profiles.map((k, v) => MapEntry('$k', v));
      }
      Map<String, dynamic>? userMap;
      if (user is Map<String, dynamic>) {
        userMap = user;
      } else if (user is Map) {
        userMap = user.map((k, v) => MapEntry('$k', v));
      }

      String? pick(String key) {
        final fromProfile = profileMap?[key]?.toString().trim();
        if (fromProfile != null && fromProfile.isNotEmpty && fromProfile != 'null') {
          return fromProfile;
        }
        final fromUser = userMap?[key]?.toString().trim();
        if (fromUser != null && fromUser.isNotEmpty && fromUser != 'null') {
          return fromUser;
        }
        final fromRoot = data[key]?.toString().trim();
        if (fromRoot != null && fromRoot.isNotEmpty && fromRoot != 'null') {
          return fromRoot;
        }
        return null;
      }

      _nickname.text = pick('nickname') ?? '';
      _bio.text = pick('bio') ?? '';
      _website.text = pick('website') ?? '';
      _phone.text = pick('phone') ?? '';
      _email.text = pick('email') ?? '';
      final birthday = pick('birthday');
      _birthday.text = birthday == null ? '' : birthday.split('T').first;
      _avatarUrl = pick('avatar') ?? pick('avatarUrl');
      final g = profileMap?['gender'] ?? data['gender'];
      if (g is num) {
        _gender = g.toInt();
      } else if (g != null) {
        _gender = int.tryParse('$g');
      }
      setState(() {});
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickAvatar() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 88,
      requestFullMetadata: false,
    );
    if (file == null) return;
    setState(() => _uploading = true);
    try {
      final bytes = await file.readAsBytes();
      final name = file.name.isNotEmpty ? file.name : 'avatar.jpg';
      final url = await widget.api.uploadFile(
        bytes: bytes,
        filename: name,
        token: widget.token,
        businessType: 'person_avatar',
      );
      if (!mounted) return;
      setState(() => _avatarUrl = url);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(e.message), backgroundColor: AppTheme.coral),
          );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.api.updateProfile(
        token: widget.token,
        nickname: _nickname.text.trim(),
        avatar: _avatarUrl,
        gender: _gender,
        birthday: _birthday.text.trim().isEmpty ? null : _birthday.text.trim(),
        bio: _bio.text.trim(),
        website: _website.text.trim(),
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        phone: _phone.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.profileUpdated)));
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    DateTime initial = DateTime(now.year - 18, now.month, now.day);
    final parsed = DateTime.tryParse(_birthday.text.trim());
    if (parsed != null) initial = parsed;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked == null) return;
    final y = picked.year.toString().padLeft(4, '0');
    final m = picked.month.toString().padLeft(2, '0');
    final d = picked.day.toString().padLeft(2, '0');
    setState(() => _birthday.text = '$y-$m-$d');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.editProfile,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: (_saving || _loading || _uploading) ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.saveProfile),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                if (_error != null) ...[
                  Material(
                    color: scheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _error!,
                        style: TextStyle(color: scheme.onErrorContainer),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: scheme.tertiaryContainer,
                        backgroundImage: _avatarUrl == null || _avatarUrl!.isEmpty
                            ? null
                            : NetworkImage(_avatarUrl!),
                        child: _avatarUrl == null || _avatarUrl!.isEmpty
                            ? Icon(
                                Icons.person_rounded,
                                size: 40,
                                color: scheme.onTertiaryContainer,
                              )
                            : null,
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: _uploading ? null : _pickAvatar,
                        icon: _uploading
                            ? const SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.photo_camera_outlined),
                        label: Text(l10n.changeAvatar),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nickname,
                  maxLength: 32,
                  decoration: InputDecoration(
                    labelText: l10n.nickname,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(l10n.gender, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                SegmentedButton<int?>(
                  emptySelectionAllowed: true,
                  segments: [
                    ButtonSegment(value: 0, label: Text(l10n.genderSecret)),
                    ButtonSegment(value: 1, label: Text(l10n.genderMale)),
                    ButtonSegment(value: 2, label: Text(l10n.genderFemale)),
                  ],
                  selected: {_gender},
                  onSelectionChanged: (s) => setState(() => _gender = s.isEmpty ? null : s.first),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _birthday,
                  readOnly: true,
                  onTap: _pickBirthday,
                  decoration: InputDecoration(
                    labelText: l10n.birthday,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _bio,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: InputDecoration(
                    labelText: l10n.bio,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _website,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: l10n.website,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.phone,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
    );
  }
}
