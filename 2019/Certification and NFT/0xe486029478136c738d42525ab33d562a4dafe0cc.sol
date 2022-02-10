['pragma solidity ^0.4.20;\n', 'contract Token {\n', '    bytes32 public standard;\n', '    bytes32 public name;\n', '    bytes32 public symbol;\n', '    uint256 public totalSupply;\n', '    uint8 public decimals;\n', '    bool public allowTransactions;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract task\n', ' {\n', '    address public adminaddr; \n', '    address public useraddr; \n', '    address public owner;\n', '    mapping (address => mapping(address => uint256)) public dep_token;\n', '    mapping (address => uint256) public dep_ETH;\n', '\n', '    function task() public\n', '    {\n', '         adminaddr = msg.sender; \n', '    }\n', '    \n', '        modifier onlyOwner() {\n', '       // require(msg.sender == owner, "Must be owner");\n', '        _;\n', '    }\n', '    \n', '    function safeAdd(uint crtbal, uint depbal) public  returns (uint) \n', '    {\n', '        uint totalbal = crtbal + depbal;\n', '        return totalbal;\n', '    }\n', '    \n', '    function safeSub(uint crtbal, uint depbal) public  returns (uint) \n', '    {\n', '        uint totalbal = crtbal - depbal;\n', '        return totalbal;\n', '    }\n', '        \n', '    function balanceOf(address token,address user) public  returns(uint256)            // show bal of perticular token in user add\n', '    {\n', '        return Token(token).balanceOf(user);\n', '    }\n', '\n', '    \n', '    \n', '    function transfer(address token, uint256 tokens)public payable                         // deposit perticular token balance to contract address (site address), can depoit multiple token   \n', '    {\n', '       // Token(token).approve.value(msg.sender)(address(this),tokens);\n', '        if(Token(token).approve(address(this),tokens))\n', '        {\n', '            dep_token[msg.sender][token] = safeAdd(dep_token[msg.sender][token], tokens);\n', '            Token(token).transferFrom(msg.sender,address(this), tokens);\n', '        }\n', '    }\n', '    \n', '    function token_withdraw(address token, address to, uint256 tokens)public payable                    // withdraw perticular token balance from contract to user    \n', '    {\n', '        if(adminaddr==msg.sender)\n', '        {  \n', '            dep_token[msg.sender][token] = safeSub(dep_token[msg.sender][token] , tokens) ;   \n', '            Token(token).transfer(to, tokens);\n', '        }\n', '    }\n', '    \n', '     function admin_token_withdraw(address token, address to, uint256 tokens)public payable  // withdraw perticular token balance from contract to user    \n', '    {\n', '        if(adminaddr==msg.sender)\n', '        {                                                              // here only admin can withdraw token                    \n', '            if(dep_token[msg.sender][token]>=tokens) \n', '            {\n', '                dep_token[msg.sender][token] = safeSub(dep_token[msg.sender][token] , tokens) ;   \n', '                Token(token).transfer(to, tokens);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function tok_bal_contract(address token) public view returns(uint256)                       // show balance of contract address\n', '    {\n', '        return Token(token).balanceOf(address(this));\n', '    }\n', '    \n', ' \n', '    function depositETH() payable external                                                      // this function deposit eth in contract address\n', '    { \n', '        \n', '    }\n', '    \n', '    function withdrawETH(address  to, uint256 value) public payable returns (bool)                            // this will withdraw eth from contract  to address(to)\n', '    {\n', '             to.transfer(value);\n', '             return true;\n', '    }\n', ' \n', '    function admin_withdrawETH(address  to, uint256 value) public payable returns (bool)  // this will withdraw eth from contract  to address(to)\n', '    {\n', '        \n', '        if(adminaddr==msg.sender)\n', '        {                                                               // only admin can withdraw ETH from user\n', '                 to.transfer(value);\n', '                 return true;\n', '    \n', '         }\n', '    }\n', '}']