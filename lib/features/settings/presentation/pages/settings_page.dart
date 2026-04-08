import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ojas_admin/features/layout/presentation/widgets/admin_layout.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController(text: 'OJAS');
  final TextEditingController _taglineController = TextEditingController(text: 'Where Great Products Meet Happy Customers');
  final TextEditingController _emailController = TextEditingController(text: 'support@ojas.com');
  final TextEditingController _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final TextEditingController _footerController = TextEditingController(text: '© 2026 OJAS. All rights reserved.');
  
  bool _enableAnnouncement = false;

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentRoute: '/settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            color: Colors.white,
            child: Row(
              children: [
                Text('Master Admin', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
                const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                Text('Website Settings', style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Website Identity & Branding',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage marketplace identity, colors, and contact details shown across the platform.',
                            style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.refresh, size: 16),
                            label: Text('Reset Changes', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.settings_backup_restore, size: 16),
                            label: Text('Reset to Default', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.save_outlined, size: 16),
                            label: Text('Save Settings', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6), // Purple
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Main Layout (2 Columns)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Forms
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            _buildBrandBasicsCard(),
                            const SizedBox(height: 24),
                            _buildLogoFaviconCard(),
                            const SizedBox(height: 24),
                            _buildAnnouncementCard(),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Right Column: Preview
                      Expanded(
                        flex: 3,
                        child: _buildPreviewCard(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandBasicsCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Brand Basics', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Text('Logo, name, tagline, and primary contact information.', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
              const Icon(Icons.palette_outlined, color: Color(0xFF8B5CF6), size: 24),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildTextField('Marketplace Name', _nameController)),
              const SizedBox(width: 20),
              Expanded(child: _buildTextField('Tagline', _taglineController)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildTextField('Support Email', _emailController)),
              const SizedBox(width: 20),
              Expanded(child: _buildTextField('Support Phone', _phoneController)),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField('Footer Message', _footerController, maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildLogoFaviconCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Logo & Favicon', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Text('Upload your brand logo and favicon images.', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
              const Icon(Icons.upload_file_outlined, color: Color(0xFF8B5CF6), size: 24),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Logo', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    _buildUploadBox('Click to upload logo', 'Max 2MB', height: 120),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Favicon', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    _buildUploadBox('Upload favicon', 'Max 2MB', height: 120),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Announcement Bar', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Text('Configure top-of-site announcement messages.', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
              const Icon(Icons.language_outlined, color: Colors.blue, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _enableAnnouncement,
                  onChanged: (v) => setState(() => _enableAnnouncement = v!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 12),
              Text('Enable announcement bar', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade700)),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField('Announcement Message', null, maxLines: 2),
          const SizedBox(height: 20),
          _buildTextField('Link', null),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Preview', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const Icon(Icons.visibility_outlined, color: Color(0xFF8B5CF6), size: 20),
            ],
          ),
          const SizedBox(height: 24),
          // Browser Window Mockup
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar mockup
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Text('/homepage', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                ),
                // Main content mockup
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Text(
                        _nameController.text,
                        style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _taglineController.text,
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        _footerController.text,
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _buildTextField(String label, TextEditingController? controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
            ),
          ),
          onChanged: (v) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildUploadBox(String title, String subtitle, {required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      // Adding a CustomPaint for dashed border or simply using a container with border for mockup.
      // A simple solid light border works for a quick representation if dashed isn't strictly enforced by a custom painter.
      // But let's build a clean minimal look representing the dashed border.
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid), // Simulating dash
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_outlined, color: Colors.grey.shade400, size: 24),
                const SizedBox(height: 8),
                Text(title, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
