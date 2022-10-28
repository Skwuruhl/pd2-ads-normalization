function MenuManager:set_mouse_sensitivity(zoomed)
	local zoom_sense = zoomed
	local sense_x, sense_y = nil

	if zoom_sense then
		sense_x = managers.user:get_setting("camera_zoom_sensitivity_x")
		sense_y = managers.user:get_setting("camera_zoom_sensitivity_y")
	else
		sense_x = managers.user:get_setting("camera_sensitivity_x")
		sense_y = managers.user:get_setting("camera_sensitivity_y")
	end

	if zoomed and managers.user:get_setting("enable_fov_based_sensitivity") and alive(managers.player:player_unit()) then
		local state = managers.player:player_unit():movement():current_state()

		if alive(state._equipped_unit) then
			local fov = managers.user:get_setting("fov_multiplier")
			local scale = math.tan((state._equipped_unit:base():zoom() or 65) * (fov + 1) / 2 / 2) / math.tan(65 * fov/2)
			sense_x = sense_x * scale
			sense_y = sense_y * scale
		end
	end

	local multiplier = temp_vec1

	mvector3.set_static(multiplier, sense_x * self._look_multiplier.x, sense_y * self._look_multiplier.y, 0)
	self._controller:get_setup():get_connection("look"):set_multiplier(multiplier)
	managers.controller:request_rebind_connections()
end