/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  DeviceEventEmitter,
  NativeModules,
  AlertIOS
} = React;

var rnweibo = React.createClass({
  weiboLogin: function(){
    var me = this;
    if(!me.weiboSubscription){
      console.log('subscribe to weibo login callback');
      me.weiboSubscription = DeviceEventEmitter.addListener(
        'weiboLoginCallback', (res) => {
          console.info(res);
          AlertIOS.alert(
            'response',
            JSON.stringify(res)
          );
          me.weiboSubscription.remove();
          delete me.weiboSubscription;
        }
      );
    }
    var rnweibo = NativeModules.rnweibo;
    rnweibo.login();
  },
  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
        <TouchableOpacity onPress={this.weiboLogin}>
          <Text style={styles.instructions}>
            点击这里微博登陆
          </Text>
        </TouchableOpacity>
      </View>
    );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('rnweibo', () => rnweibo);
