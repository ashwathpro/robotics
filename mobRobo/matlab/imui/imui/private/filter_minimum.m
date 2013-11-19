function varargout = filter_minimum(varargin)

if nargin == 0
	p1 = struct( ...
		'Name',					'Radius (in pixel)', ...
		'Style',				'integer', ...
		'DefaultValue',			3, ...
		'Max',					64, ...
		'Min',					2, ...
		'LargeStep',			8, ...
		'SmallStep',			1);
	P = struct( ...
		'FilterName',			'Minimnm', ...
		'Class',				'', ...
		'AvailableImageType',	[0 0 0 1 1], ...
		'ParameterNumber',		1, ...
		'Parameters', 			{ {p1} });
	varargout{1} = P;
else
	CX = varargin{1};
	FUNPARA = varargin{2};
	if isrgb(CX)
		varargout{1} = cat(3, ...
			ordfilt2(CX(:, :, 1), 1, ones(FUNPARA{1})), ...
			ordfilt2(CX(:, :, 2), 1, ones(FUNPARA{1})), ...
			ordfilt2(CX(:, :, 3), 1, ones(FUNPARA{1})) );
	else
		varargout{1} = ordfilt2(CX, 1, ones(FUNPARA{1}));
	end
end