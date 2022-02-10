['pragma solidity ^0.5.1;\n', '\n', 'contract KingoftheBill {\n', '    address owner = msg.sender;\n', '    address payable donee = 0xc7464dbcA260A8faF033460622B23467Df5AEA42;\n', '    \n', '    struct Record {\n', '        string donorName; \n', '        uint donation; \n', '    }\n', '\n', '    mapping(address => Record) private donorsbyAddress;\n', '\n', '    address[] public addressLUT;\n', '\n', '    uint public sumDonations;                       \n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function donate(string memory _name) public payable {\n', '        require(msg.value > 0);\n', '        donorsbyAddress[msg.sender].donorName = _name; \n', '        donorsbyAddress[msg.sender].donation = donorsbyAddress[msg.sender].donation + msg.value;\n', '        sumDonations = sumDonations + msg.value;\n', '        addressLUT.push(msg.sender);\n', '        donee.transfer(msg.value);   \n', '    }\n', '\n', '    function getDonationsofDonor (address _donor) external view returns(uint){ \n', '        return donorsbyAddress[_donor].donation;\n', '    }\n', '\n', '    function getNameofDonor (address _donor) external view returns(string memory){\n', '        return donorsbyAddress[_donor].donorName;\n', '    }\n', '\n', '    function getaddressLUT() external view returns(address[] memory){\n', '        return addressLUT;\n', '    }\n', '\n', '    function killContract() public onlyOwner {\n', '        selfdestruct(donee);\n', '    }\n', '\n', '}']