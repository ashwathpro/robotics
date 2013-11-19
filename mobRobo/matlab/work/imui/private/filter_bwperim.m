function varargout = filter_bwperim(varargin)

if nargin == 0
	p1 = struct( ...
		'Name',					'Connectivity', ...
		'Style',				'popup', ...
		'DefaultValue',			2, ...
		'Items',				{ {'4 connected neighborhood', '8 connected neighborhood'} } );
	P = struct( ...
		'FilterName',			'Perimeter Determination', ...
		'AvailableImageType',	[0 1 0 0 0], ...
		'Class',				'morphological', ...
		'ParameterNumber',		1, ...
		'Parameters', 			{ {p1} });
	varargout{1} = P;
else
	CX = varargin{1};
	FUNPARA = varargin{2};
	varargout{1} = bwperim(CX,  FUNPARA{1} * 4);
end