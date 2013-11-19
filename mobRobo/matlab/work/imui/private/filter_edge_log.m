function varargout = filter_edge_log(varargin)


if nargin == 0
	p1 = struct( ...
		'Name',					'Threshold', ...
		'Style',				'single', ...
		'DefaultValue',			0.5, ...
		'Max',					1, ...
		'Min',					0, ...
		'LargeStep',			1 / 10, ...
		'SmallStep',			1 / 100);
	p2 = struct( ...
		'Name',					'Automatic threshold', ...
		'Style',				'check', ...
		'DefaultValue',			0);
	p3 = struct( ...
		'Name',					'Sigma', ...
		'Style',				'single', ...
		'DefaultValue',			2, ...
		'Max',					6, ...
		'Min',					0.01, ...
		'LargeStep',			0.5, ...
		'SmallStep',			0.01);
	P = struct( ...
		'FilterName',			'Laplacian-Gaussian edge detection', ...
		'AvailableImageType',	[0 0 0 1 0], ...
		'Class',				'edge', ...
		'ParameterNumber',		3, ...
		'Parameters', 			{ { p1, p2, p3} });
	varargout{1} = P;
else
	CX = varargin{1};
	FUNPARA = varargin{2};
	if ~FUNPARA{2}
		threshold = FUNPARA{1};
	else
		threshold = [];
	end
	BW = edge(CX, 'log', threshold, FUNPARA{3});
	varargout{1} = BW;
end