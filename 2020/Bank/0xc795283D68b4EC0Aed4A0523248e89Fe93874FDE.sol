['/*\n', 'Website: \n', '   -  TTT.finance\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface Token{\n', '    \n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '\n', '}\n', '\n', 'contract SafeMath {\n', '    function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0)||(z/x == y));\n', '        return z;\n', '    }\n', '\n', '}\n', '\n', 'contract TttTokenSale is SafeMath {\n', '    address payable admin;\n', '    Token public tokenContract;\n', '    uint256 public tokenPrice;\n', '    uint256 public tokensSold;\n', '\n', '    event Sell(address _buyer, uint256 _amount);\n', '\n', '    constructor(Token _tokenContract, uint256 _tokenPrice) public {\n', '        admin = msg.sender;\n', '        tokenContract = _tokenContract;\n', '        tokenPrice = _tokenPrice;\n', '    }\n', '\n', '    function buyTokens(uint256 _numberOfTokens) public payable {\n', '        uint256 numberOfTokens =safeMult(_numberOfTokens,1e18);\n', '        require(\n', '            msg.value == safeMult(_numberOfTokens,tokenPrice),\n', '            "Number of tokens does not match with the value"\n', '        );\n', '        require(\n', '            tokenContract.balanceOf(address(this)) >= numberOfTokens,\n', '            "Contact does not have enough tokens"\n', '        );\n', '        require(\n', '            tokenContract.transfer(msg.sender, numberOfTokens),\n', '            "Some problem with token transfer"\n', '        );\n', '        tokensSold += _numberOfTokens;\n', '        emit Sell(msg.sender, numberOfTokens);\n', '    }\n', '    \n', '    function withdraw() external { \n', '    require(msg.sender == admin, "Only the admin can call this function");\n', '    admin.transfer(address(this).balance);\n', '    }\n', '   function setTokenExchangeRate(uint256 _tokenExchangeRate) external {\n', '       require(msg.sender == admin, "Only the admin can call this function");\n', '        require(_tokenExchangeRate != 0);\n', '        require(_tokenExchangeRate != tokenPrice);\n', '\n', '        tokenPrice = _tokenExchangeRate;\n', '    }\n', '\n', '    function endSale() public {\n', '        require(msg.sender == admin, "Only the admin can call this function");\n', '        require(\n', '            tokenContract.transfer(\n', '                msg.sender,\n', '                tokenContract.balanceOf(address(this))\n', '            ),\n', '            "Unable to transfer tokens to admin"\n', '        );\n', '        // destroy contract\n', '        selfdestruct(admin);\n', '    }\n', '}']