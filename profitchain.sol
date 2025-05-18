// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProfitChain {
    address public systemOwner = 0xD5B0780E196A7D0ac60BfA057576B5c91d8F3826;
    
    struct User {
        address upline;
        address[] downline;
        uint256 level;
    }

    mapping(address => User) public users;
    uint256[] public levelFees = [2,4,8,16,32,64,128,256,512,1024]; // POL fees

    // Registration via referral link (upline auto-set)
    function register(address _upline) external {
        require(users[msg.sender].upline == address(0), "Already registered");
        if (_upline != address(0)) {
            users[_upline].downline.push(msg.sender);
        }
        users[msg.sender].upline = _upline;
    }

    // Level Upgrade & Auto-Distribution
    function upgradeLevel(uint256 _level) external payable {
        require(_level >=1 && _level <=10, "Invalid level");
        uint256 fee = levelFees[_level-1] * 1e18; // Convert POL to wei
        require(msg.value == fee, "Incorrect fee");

        address upline = users[msg.sender].upline;

        // Direct Referral (30%)
        if (upline != address(0)) {
            payable(upline).transfer(fee * 30 / 100);
        }

        // Upline (30%) - 30 members ko 1% each
        address currentUpline = upline;
        for (uint i=0; i<30 && currentUpline != address(0); i++) {
            payable(currentUpline).transfer(fee * 1 / 100);
            currentUpline = users[currentUpline].upline;
        }

        // Downline (30%) - 30 members ko 1% each
        User storage user = users[msg.sender];
        for (uint i=0; i<30 && i<user.downline.length; i++) {
            payable(user.downline[i]).transfer(fee * 1 / 100);
        }

        // System Owner (5%)
        payable(systemOwner).transfer(fee * 5 / 100);
    }
}
