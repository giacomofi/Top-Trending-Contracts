['/*\n', 'Besides the standard ERC20 token functions, ChefToken smart contract has the following functions implemented:\n', '- servicePaymentWithCharityPercentage:\n', '    After the client and service provider agree on a service and it&#39;s price, the agreed amount is transfered to the CookUp smart contract address\n', '    to ensure that the service provider will be paid. Once the service has been completed, the CookUp application calls this function, \n', '    which then calculates the appropriate percentages of the price for each involved party: the service provider, CookUp and the charity organization.\n', '    CookUp&#39;s percentage is determined by the variable cookUpFee, while the charity&#39;s percentage is determined by the variable charityDonation.\n', '    These two fees are substracted from the total service price, and the remaining amount is sent to the service provider.\n', '    The funds that will be sent to charity organization are first stored at a temporary address.\n', '- releaseAdvisorsTeamTokens:\n', '    This function is used to transfer CHEF tokens reserved for CookUp partners and advisors to a temporary address every month, \n', '    for twelve months. It can only be called by the owner and has a built in condition which prevents the funds from being released \n', '    earlier than intended.\n', '- burn:\n', '    This function will be used only to burn unsold tokens during ICO.\n', '*/\n', '\n', 'pragma solidity 0.4.23;\n', '  library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '  \n', 'contract Ownable{\n', '   address public chefOwner; \n', '   \n', '   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '   \n', '   function Ownable() public {\n', '        chefOwner = msg.sender;\n', '    }\n', '   \n', '    modifier onlyOwner() {\n', '        require(msg.sender == chefOwner);\n', '        _;\n', '    }\n', '      \n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(chefOwner, newOwner);\n', '        chefOwner = newOwner;\n', '    }\n', '}  \n', '\n', '\n', 'contract ChefTokenInterface {\n', '    \n', '    function totalSupply() public view returns (uint256 supply);\n', '    function balanceOf(address tokenOwner) public view returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);\n', '    function transfer(address to, uint256 value) public returns (bool success);\n', '    function servicePaymentWithCharityPercentage(address to, uint256 value) public returns  (bool success);\n', '    function approve(address spender, uint256 value) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success);\n', '    function approveAndCall(address spender, uint256 value, bytes extraData) public returns (bool success);\n', '    function burn(uint256 value) public returns (bool success);\n', '    function setCharityDonation(uint256 donation) public returns (bool success);\n', '    function setCookUpFee(uint256 fee) public returns (bool success);\n', '    function setCharityAddress(address tempAddress) public returns (bool success);\n', '    function setAdvisorsTeamAddress(address tempAddress) public returns (bool success);\n', '    function releaseAdvisorsTeamTokens () public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event PaymentWithCharityPercentage (address indexed from, address indexed to, address indexed charity, uint256 value, uint256 charityValue);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '}\n', '\n', 'interface tokenRecipient { \n', '    function receiveApproval(address from, uint256 value, address token, bytes extraData) external; \n', '}\n', '\n', '\n', 'contract ChefToken is Ownable, ChefTokenInterface {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply;\n', '    uint256 public cookUpFee;\n', '    uint256 public charityDonation;\n', '    address public tempCharity;\n', '    address public tempAdvisorsTeam;\n', '    uint256 public tokensReleasedAdvisorsTeam;\n', '    uint256 initialReleaseDate; \n', '    uint256 releaseSum; \n', '    mapping (address => uint256) public balanceOf; \n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    \n', '    \n', '    function ChefToken () public {\n', '        totalSupply = 630*(10**6)*(10**18);   \n', '        balanceOf[msg.sender] = totalSupply;  \n', '        name = "CHEF";                  \n', '        symbol = "CHEF";\n', '    \n', '        tempCharity = address(0);\n', '        tempAdvisorsTeam = address(0);\n', '        tokensReleasedAdvisorsTeam = 0;\n', '        initialReleaseDate = 1530396000;\n', '        releaseSum = 1575*(10**5)*(10**18);\n', '        cookUpFee = 7;\n', '        charityDonation=3;\n', '    }\n', '\n', '\n', '    function totalSupply() public view returns (uint256 supply) {\n', '        return totalSupply;\n', '    }\n', '\t\n', '\n', '    function balanceOf(address _tokenOwner) public view returns (uint256 balance) {\n', '        return balanceOf[_tokenOwner];\n', '    }\n', '\t\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require(_to != address(0));\n', '        require(balanceOf[_from] >= _value); \n', '        uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]); \n', '        balanceOf[_from] = balanceOf[_from].sub(_value); \n', '        balanceOf[_to] = balanceOf[_to].add(_value); \n', '        emit Transfer(_from, _to, _value); \n', '        assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances); \n', '    }\n', '\t\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\t\n', '\n', '    function servicePaymentWithCharityPercentage(address _to, uint256 _value)  public onlyOwner returns  (bool success) {\n', '        uint256 servicePercentage = 100 - cookUpFee - charityDonation;\n', '        _transfer(msg.sender, _to, _value.mul(servicePercentage).div(100));\n', '        _transfer(msg.sender, tempCharity, _value.mul(charityDonation).div(100));\n', '        emit PaymentWithCharityPercentage (msg.sender, _to, tempCharity, _value.mul(servicePercentage).div(100), _value.mul(charityDonation).div(100));\n', '        return true;\n', '    }\n', '\t\t\n', '\n', '    function allowance(address _tokenOwner, address _spender) public view returns (uint256 remaining) {\n', '        return allowance[_tokenOwner][_spender];\n', '    }\n', '    \n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);   \n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\t\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '\n', '    function burn(uint256 _value) public onlyOwner returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);  \n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  \n', '        totalSupply = totalSupply.sub(_value);  \n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function setCharityAddress(address _tempAddress) public onlyOwner returns (bool success) {\n', '        tempCharity = _tempAddress;\n', '        return true;    \n', '    }\n', '    \n', '    function setCookUpFee(uint256 _fee) public onlyOwner returns (bool success) {\n', '        cookUpFee = _fee;\n', '        return true;    \n', '    }\n', '    \n', '    \n', '     function setCharityDonation(uint256 _donation) public onlyOwner returns (bool success) {\n', '        charityDonation = _donation;\n', '        return true;    \n', '    }\n', '    \n', '    \n', '    function setAdvisorsTeamAddress(address _tempAddress) public onlyOwner returns (bool success) {\n', '        tempAdvisorsTeam = _tempAddress;\n', '        return true;    \n', '    }\n', '\n', '\n', '    function releaseAdvisorsTeamTokens () public onlyOwner returns (bool success) {\n', '        uint256 releaseAmount = releaseSum.div(12);\n', '        if((releaseSum >= (tokensReleasedAdvisorsTeam.add(releaseAmount))) && (initialReleaseDate+(tokensReleasedAdvisorsTeam.mul(30 days).mul(12).div(releaseSum)) <= now)) {\n', '            tokensReleasedAdvisorsTeam=tokensReleasedAdvisorsTeam.add(releaseAmount);\n', '            _transfer(chefOwner,tempAdvisorsTeam,releaseAmount);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }    \n', '}']