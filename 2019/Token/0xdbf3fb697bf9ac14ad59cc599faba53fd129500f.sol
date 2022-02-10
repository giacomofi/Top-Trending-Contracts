['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-04\n', '*/\n', '\n', 'pragma solidity 0.5.8;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '/**\n', ' * @title SwapContract\n', ' * @dev A contract to depsoit Tokens and get your address registered for bep2 receival\n', ' */\n', 'contract BawSwapContract{\n', '    \n', '    ERC20 public token;\n', '    address public owner;\n', '    uint public bb;\n', '    \n', '    /**\n', '    * @param _token An address for ERC20 token which would be swaped be bep2\n', '    */\n', '    constructor(ERC20 _token) public {\n', '        token = _token;\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Caller is not the owner");\n', '        _;\n', '    }\n', '    \n', '    event OwnerChanged(address oldOwner, address newOwner);\n', '    \n', '    /**\n', '    * @dev only to be called by the owner of Swap contract\n', '    * @param _newOwner An address to replace the old owner with.\n', '    */\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        emit OwnerChanged(msg.sender, owner);\n', '    }\n', '    \n', '    event Swaped(uint tokenAmount, string BNB_Address);\n', '    \n', '    /**\n', '    * @param tokenAmount Amount of tokens to swap with bep2\n', '    * @param BNB_Address address of Binance Chain to which to receive the bep2 tokens\n', '    */\n', '    function swap(uint tokenAmount, string memory BNB_Address) public returns(bool) {\n', '        \n', '        bool success = token.transferFrom(msg.sender, owner, tokenAmount);\n', '        \n', '        if(!success) {\n', '            revert("Transfer of tokens to Swap contract failed.");\n', '        }\n', '        \n', '        emit Swaped(tokenAmount, BNB_Address);\n', '        \n', '        return true;\n', '        \n', '    }\n', '    \n', '}']
['pragma solidity 0.5.8;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '/**\n', ' * @title SwapContract\n', ' * @dev A contract to depsoit Tokens and get your address registered for bep2 receival\n', ' */\n', 'contract BawSwapContract{\n', '    \n', '    ERC20 public token;\n', '    address public owner;\n', '    uint public bb;\n', '    \n', '    /**\n', '    * @param _token An address for ERC20 token which would be swaped be bep2\n', '    */\n', '    constructor(ERC20 _token) public {\n', '        token = _token;\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Caller is not the owner");\n', '        _;\n', '    }\n', '    \n', '    event OwnerChanged(address oldOwner, address newOwner);\n', '    \n', '    /**\n', '    * @dev only to be called by the owner of Swap contract\n', '    * @param _newOwner An address to replace the old owner with.\n', '    */\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        emit OwnerChanged(msg.sender, owner);\n', '    }\n', '    \n', '    event Swaped(uint tokenAmount, string BNB_Address);\n', '    \n', '    /**\n', '    * @param tokenAmount Amount of tokens to swap with bep2\n', '    * @param BNB_Address address of Binance Chain to which to receive the bep2 tokens\n', '    */\n', '    function swap(uint tokenAmount, string memory BNB_Address) public returns(bool) {\n', '        \n', '        bool success = token.transferFrom(msg.sender, owner, tokenAmount);\n', '        \n', '        if(!success) {\n', '            revert("Transfer of tokens to Swap contract failed.");\n', '        }\n', '        \n', '        emit Swaped(tokenAmount, BNB_Address);\n', '        \n', '        return true;\n', '        \n', '    }\n', '    \n', '}']