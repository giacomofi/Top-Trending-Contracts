['pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '}\n', '\n', '\n', 'contract SeparateDistribution {\n', '  // The token interface\n', '  ERC20 public token;\n', '\n', '  // The address of token holder that allowed allowance to contract\n', '  address public tokenWallet;\n', '\n', '  constructor() public\n', '   {\n', '    token = ERC20(0xF3336E5DC23b01758CF03F6d4709D46AbA35a6Bd);\n', '    tokenWallet =  address(0xc45e9c64eee1F987F9a5B7A8E0Ad1f760dEFa7d8);  \n', '    \n', '  }\n', '  \n', '  function addExisitingContributors(address[] _address, uint256[] tokenAmount) public {\n', '        require (msg.sender == address(0xc45e9c64eee1F987F9a5B7A8E0Ad1f760dEFa7d8));\n', '        for(uint256 a=0;a<_address.length;a++){\n', '            if(!token.transferFrom(tokenWallet,_address[a],tokenAmount[a])){\n', '                revert();\n', '            }\n', '        }\n', '    }\n', '    \n', '    function updateTokenAddress(address _address) external {\n', '        require(_address != 0x00);\n', '        token = ERC20(_address);\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '}\n', '\n', '\n', 'contract SeparateDistribution {\n', '  // The token interface\n', '  ERC20 public token;\n', '\n', '  // The address of token holder that allowed allowance to contract\n', '  address public tokenWallet;\n', '\n', '  constructor() public\n', '   {\n', '    token = ERC20(0xF3336E5DC23b01758CF03F6d4709D46AbA35a6Bd);\n', '    tokenWallet =  address(0xc45e9c64eee1F987F9a5B7A8E0Ad1f760dEFa7d8);  \n', '    \n', '  }\n', '  \n', '  function addExisitingContributors(address[] _address, uint256[] tokenAmount) public {\n', '        require (msg.sender == address(0xc45e9c64eee1F987F9a5B7A8E0Ad1f760dEFa7d8));\n', '        for(uint256 a=0;a<_address.length;a++){\n', '            if(!token.transferFrom(tokenWallet,_address[a],tokenAmount[a])){\n', '                revert();\n', '            }\n', '        }\n', '    }\n', '    \n', '    function updateTokenAddress(address _address) external {\n', '        require(_address != 0x00);\n', '        token = ERC20(_address);\n', '    }\n', '}']