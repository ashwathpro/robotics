function varargout = filter_bwulterode(varargin)


if nargin == 0
	p1 = struct( ...
		'Name',					'Method', ...
		'Style',				'popup', ...
		'DefaultValue',			1, ...
		'Items',				{ {'Euclidean', 'Cityblock', 'Chessboard', 'Quasi-euclidean'} } );
	p2 = struct( ...
		'Name',					'Connectivity', ...
		'Style',				'popup', ...
		'DefaultValue',			2, ...
		'Items',				{ {'4 connected neighborhood', '8 connected neighborhood'} } );
	P = struct( ...
		'FilterName',			'Ultimate erosion', ...
		'AvailableImageType',	[0 1 0 0 0], ...
		'Class',				'morphological', ...
		'ParameterNumber',		2, ...
		'Parameters', 			{ { p1, p2} });
	varargout{1} = P;
else
	CX = varargin{1};
	FUNPARA = varargin{2};
	method = {'euclidean', 'cityblock', 'chessboard', 'quasi-euclidean'};
	varargout{1} = bwulterode(CX, method{FUNPARA{1}}, FUNPARA{2} * 4);
end