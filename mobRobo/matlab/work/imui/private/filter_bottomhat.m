function varargout = filter_bottomhat(varargin)

if nargin == 0
	p1 = struct( ...
		'Name',					'Structuring element', ...
		'Style',				'strel', ...
		'DefaultValue',			strel('diamond', 2));

	P = struct( ...
		'FilterName',			'Bottom hat filtering', ...
		'AvailableImageType',	[0 1 0 1 0], ...
		'Class',				'morphological', ...
		'ParameterNumber',		1, ...
		'Parameters', 			{ {p1} });
	varargout{1} = P;
else
	CX = varargin{1};
	FUNPARA = varargin{2};
	varargout{1} = imbothat(CX, FUNPARA{1});
end