#!/usr/bin/ruby
#coding: UTF-8
require 'gtk2'
Gtk.init

class PSelector < Gtk::Image
  attr_reader :wwidth, :wheight,:fator,:swidth,:sheight,:wimg,:simg
	def initialize(fator=4)
		super()
		self.set_app_paintable(true)
		@wind = Gdk::Window.default_root_window
		@wwidth,@wheight = @wind.size #wwidth e wheight repesenta o tamanho original da tela
		@fator= fator #proporção do redimensionamento
		@swidth = @wwidth/@fator #swidth e sheight é o tamanho redimensionado
		@sheight = @wheight/@fator
		self.set_size_request(@swidth,@sheight)
		signal_connect("motion_notify_event")  { |w,e| puts "arrastou" }#não imprime quando passa o mouse em cima do componente
		
		
		update_image()
		
	end

	def update_image(intervalo=2000)#intervalo= tempo entre uma atualização e outra
			@wind = Gdk::Window.default_root_window
			@simg = @wind.get_image(0,0,@swidth,@sheight)
		GLib::Timeout.add(intervalo) do #thread que mantem a imagem atualizada
			GC.start()
			subsample()
			true
		end

	end

	###(imgModelo, w, h, imgFinal, x=0, y=0)
	def subsample()
		@wimg = @wind.get_image(0,0,@wwidth,@wheight)
		@swidth.times{|w|
			@sheight.times{|h|
				@simg.put_pixel(w,h,(@wimg.get_pixel((w*@fator),(h*@fator))))
			}
		}
		self.image = @simg
		
	end

	#fazer função pra pegar posição do click


end
