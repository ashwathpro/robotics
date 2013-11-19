import java.io.*;
import java.lang.*;
import java.lang.String.*;
import java.lang.Character.*;
public class str
{
public static void main(String str[])throws IOException
{
DataInputStream is=new DataInputStream(System.in);
if(isUpperCase('K'))
System.out.println("Enter a str.:");

System.out.println("Enter a str.:");
String s=is.readLine();
int l=s.length();
System.out.println(l);
System.out.println(s.trim());
System.out.println(s.charAt(5));
System.out.println(s.substring(0,5));
StringBuffer s1=new StringBuffer(s);
System.out.println(s1.reverse());
System.out.println(s1.reverse());
char c[]=new char[15];
s1.getChars(0,7,c,0);
System.out.println(c);

}
}
