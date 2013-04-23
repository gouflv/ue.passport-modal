var path = require('path');
var lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet;
var mountFolder = function (connect, dir) {
    return connect.static(path.resolve(dir));
};

module.exports = function(grunt) {	
	require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),

		connect: {
			options: {
				port: 9001
			},
			livereload: {
				options: {
					middleware: function(connect, options) {
						return [
							lrSnippet,
							mountFolder(connect, options.base)
						];
					}
				}
			}
		},
		watch: {
			coffee: {
                files: ['js/{,*/}*.coffee'],
                tasks: ['coffee']
            },
			livereload: {
				files: [
					'{,*/}*.html',
					'css/{,*/}*.css',
					'js/{,*/}*.js'
				],
				tasks: ['livereload']
			}
		},
		coffee: {
			compile: {
				options: {
					sourceMap: false
				},
				expand: true,
				cwd: 'js',
				src: ['*.coffee'],
				dest: 'js',
				ext: '.coffee.js'
			}
		},
		cssmin: {
			options: {
				banner: '/*! <%= pkg.name %>-<%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd HH:MM:ss") %> */',
				keepSpecialComments: 0,
				keepBreaks: true
			},
			dist: {
                expand: true,
                cwd: 'css',
                src: ['*.css'],
                dest: 'dist',
                ext: '.min.css'
            }
		},
		uglify: {
			options: {
				banner: '/*! <%= pkg.name %>-<%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd HH:MM:ss") %> */\n',
				preserveComments: false
			},
			dist: {
                expand: true,
                cwd: 'js',
                src: ['*.js'],
                dest: 'dist',
                ext: '.min.js'
            }
		},
		open: {
            server: {
                path: 'http://localhost:<%= connect.options.port %>/index.html'
            }
        },
        jshint: {
			all: [
				'Gruntfile.js',
				'js/{,*/}*.js'
			],
            config: ['Gruntfile.js']
        }
	});

	grunt.renameTask('regarde', 'watch');

	grunt.registerTask('server', [
		'livereload-start',
		'coffee',
		'connect',
		'watch'
	]);

	grunt.registerTask('build', [
		'coffee',
        'uglify',
		'cssmin'
	]);

	grunt.registerTask('default', [
		'server'
	]);

};