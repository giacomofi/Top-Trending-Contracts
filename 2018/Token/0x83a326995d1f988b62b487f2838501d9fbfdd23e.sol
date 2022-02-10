['// Tarka Pre-Sale token smart contract.\n', '// Developed by Phenom.Team <info@phenom.team>\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '\n', '/**\n', ' *   @title SafeMath\n', ' *   @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract PreSalePTARK {\n', '    using SafeMath for uint256;\n', '    //Owner address\n', '    address public owner;\n', '    //Public variables of the token\n', '    string public name  = "Tarka Pre-Sale Token";\n', '    string public symbol = "PTARK";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 0;\n', '    mapping (address => uint256) public balances;\n', '    // Events Log\n', '    event Transfer(address _from, address _to, uint256 amount); \n', '    event Burned(address _from, uint256 amount);\n', '    // Modifiers\n', '    // Allows execution by the contract owner only\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }  \n', '\n', '   /**\n', '    *   @dev Contract constructor function sets owner address\n', '    */\n', '    function PreSalePTARK() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '   /**\n', '    *   @dev Allows owner to transfer ownership of contract\n', '    *   @param _newOwner      newOwner address\n', '    */\n', '    function transferOwnership(address _newOwner) external onlyOwner {\n', '        require(_newOwner != address(0));\n', '        owner = _newOwner;\n', '    }\n', '\n', '   /**\n', '    *   @dev Get balance of investor\n', "    *   @param _investor     investor's address\n", '    *   @return              balance of investor\n', '    */\n', '    function balanceOf(address _investor) public constant returns(uint256) {\n', '        return balances[_investor];\n', '    }\n', '\n', '   /**\n', '    *   @dev Mint tokens\n', '    *   @param _investor     beneficiary address the tokens will be issued to\n', '    *   @param _mintedAmount number of tokens to issue\n', '    */\n', '    function mintTokens(address _investor, uint256 _mintedAmount) external onlyOwner {\n', '        require(_mintedAmount > 0);\n', '        balances[_investor] = balances[_investor].add(_mintedAmount);\n', '        totalSupply = totalSupply.add(_mintedAmount);\n', '        Transfer(this, _investor, _mintedAmount);\n', '        \n', '    }\n', '\n', '   /**\n', '    *   @dev Burn Tokens\n', '    *   @param _investor     token holder address which the tokens will be burnt\n', '    */\n', '    function burnTokens(address _investor) external onlyOwner {   \n', '        require(balances[_investor] > 0);\n', '        uint256 tokens = balances[_investor];\n', '        balances[_investor] = 0;\n', '        totalSupply = totalSupply.sub(tokens);\n', '        Burned(_investor, tokens);\n', '    }\n', '}']