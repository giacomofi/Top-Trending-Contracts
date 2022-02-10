['pragma solidity 0.4.25;\n', '\n', 'interface COSS {\n', '  function sendTokens(address _destination, address _token, uint256 _amount) public;\n', '  function sendEther(address _destination, uint256 _amount) payable public;\n', '}\n', '\n', 'contract FSAContract{\n', '    address owner = 0xc17cbf9917ca13d5263a8d4069e566be23db1b09;\n', '    address cossContract = 0x9e96604445ec19ffed9a5e8dd7b50a29c899a10c;\n', ' \n', '     modifier onlyOwner(){\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function sendTokens(address _destination, address _token, uint256 _amount) public onlyOwner {\n', '         COSS(cossContract).sendTokens(_destination,_token,_amount);\n', '    }\n', '    \n', '    function sendEther(address _destination, uint256 _amount) payable public onlyOwner {\n', '        COSS(cossContract).sendEther(_destination,_amount);\n', '    }\n', '}']
['pragma solidity 0.4.25;\n', '\n', 'interface COSS {\n', '  function sendTokens(address _destination, address _token, uint256 _amount) public;\n', '  function sendEther(address _destination, uint256 _amount) payable public;\n', '}\n', '\n', 'contract FSAContract{\n', '    address owner = 0xc17cbf9917ca13d5263a8d4069e566be23db1b09;\n', '    address cossContract = 0x9e96604445ec19ffed9a5e8dd7b50a29c899a10c;\n', ' \n', '     modifier onlyOwner(){\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function sendTokens(address _destination, address _token, uint256 _amount) public onlyOwner {\n', '         COSS(cossContract).sendTokens(_destination,_token,_amount);\n', '    }\n', '    \n', '    function sendEther(address _destination, uint256 _amount) payable public onlyOwner {\n', '        COSS(cossContract).sendEther(_destination,_amount);\n', '    }\n', '}']